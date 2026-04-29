# Detailed Line-By-Line Execution Explanation

To deeply understand how the Campus Event System functions, we will trace a core feature—**User Login**—line by line. This will demonstrate exactly how the frontend, backend controller, database utility, and data access object (DAO) interact to pass data across the system.

---

## 1. The Utility Layer: `DBConnection.java`

This file is responsible for establishing a connection to the MySQL database.

```java
1: package com.campus.eventsystem.util;
```
> **Line 1:** Declares the package where this utility class lives.

```java
3: import java.sql.Connection;
4: import java.sql.DriverManager;
```
> **Lines 3-4:** Imports the essential JDBC classes required to connect to SQL databases.

```java
6: public class DBConnection {
```
> **Line 6:** Defines the class `DBConnection`.

```java
8:     private static final String URL = "jdbc:mysql://localhost:3306/campus_event_db?useSSL=false&serverTimezone=UTC";
9:     private static final String USER = "root";
10:     private static final String PASSWORD = "";
```
> **Lines 8-10:** Defines constant `static final` strings for the database configuration. `URL` points to the local MySQL server on port 3306 and the specific database `campus_event_db`. `USER` and `PASSWORD` are the credentials.

```java
12:     public static Connection getConnection() {
```
> **Line 12:** Declares a public static method `getConnection()` that returns a `Connection` object. Being `static` means we can call `DBConnection.getConnection()` from anywhere without instantiating the class.

```java
13:         Connection connection = null;
14: 
15:         try {
16:             Class.forName("com.mysql.cj.jdbc.Driver");
```
> **Lines 13-16:** Initializes a null connection object. Opens a `try` block to catch potential SQL errors. `Class.forName(...)` explicitly loads the MySQL JDBC driver into the application's memory at runtime.

```java
17:             connection = DriverManager.getConnection(URL, USER, PASSWORD);
18:             System.out.println("Database connected!");
```
> **Lines 17-18:** The `DriverManager` takes the URL and credentials defined above, establishes a physical network connection to the MySQL server, and assigns it to the `connection` variable. Prints a success message to the console.

```java
19:         } catch (Exception e) {
20:             e.printStackTrace();
21:         }
```
> **Lines 19-21:** Catches any errors (like incorrect password or database being offline) and prints the stack trace to the console for debugging.

```java
23:         return connection;
24:     }
25: }
```
> **Lines 23-25:** Returns the active `Connection` object to whatever class called it.

---

## 2. The Data Access Layer: `UserDAO.java` (Login Method)

This class interacts directly with the database using the connection we just created.

```java
13:     public User login(String email, String password) {
```
> **Line 13:** Defines the `login` method taking an `email` and `password` string from the user. It promises to return a `User` object if successful.

```java
14:         User user = null;
```
> **Line 14:** Initializes the `user` object to null. If authentication fails, it will remain null.

```java
16:         String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
```
> **Line 16:** Defines a parameterized SQL query. The `?` symbols prevent SQL injection attacks.

```java
18:         try (Connection conn = DBConnection.getConnection();
19:              PreparedStatement stmt = conn.prepareStatement(sql)) {
```
> **Lines 18-19:** This is a "try-with-resources" block. It calls our utility `DBConnection.getConnection()` and creates a `PreparedStatement` using our SQL string. When this block finishes, Java automatically closes the connection to prevent memory leaks.

```java
21:             stmt.setString(1, email);
22:             stmt.setString(2, password);
```
> **Lines 21-22:** Replaces the first `?` in the SQL query with the `email` variable, and the second `?` with the `password` variable.

```java
24:             ResultSet rs = stmt.executeQuery();
```
> **Line 24:** Executes the final SQL query (`SELECT * FROM users WHERE email='...' AND password='...'`) against the database. The result is stored in a `ResultSet` object (`rs`).

```java
26:             if (rs.next()) {
```
> **Line 26:** Moves the `ResultSet` cursor to the first row of results. If a row exists (meaning the email/password matched a user in the DB), it returns `true`.

```java
27:                 user = new User();
28:                 user.setId(rs.getInt("id"));
29:                 user.setFullName(rs.getString("full_name"));
30:                 // ... (other setters)
36:                 user.setBlocked(rs.getBoolean("blocked"));
```
> **Lines 27-36:** Instantiates a new empty `User` object (The Model). It then extracts the data column-by-column from the database row (`rs.getInt()`, `rs.getString()`) and assigns them to the Java object using setter methods.

```java
38:                 if (user.isBlocked()) {
39:                     return null;
40:                 }
41:             }
```
> **Lines 38-41:** A business logic check: If the user is flagged as blocked in the database, the method immediately aborts and returns `null`, denying them login.

```java
43:         } catch (Exception e) {
44:             e.printStackTrace();
45:         }
46: 
47:         return user;
48:     }
```
> **Lines 43-48:** Catches SQL exceptions. Finally, returns the populated `User` object (or `null` if it failed/was not found) back to the Controller.

---

## 3. The Controller Layer: `LoginServlet.java`

The Controller acts as the bridge between the Frontend (JSP) and the Backend (DAO).

```java
11: @WebServlet("/login")
12: public class LoginServlet extends HttpServlet {
```
> **Lines 11-12:** The `@WebServlet` annotation tells Tomcat server to route any HTTP requests going to `http://localhost:8080/event-system/login` to this specific Java class.

```java
14:     private final UserDAO userDAO = new UserDAO();
```
> **Line 14:** Instantiates the `UserDAO` class so we have access to its database methods.

```java
16:     @Override
17:     protected void doGet(HttpServletRequest request, HttpServletResponse response)
18:             throws ServletException, IOException {
19:         request.getRequestDispatcher("/views/login.jsp").forward(request, response);
20:     }
```
> **Lines 16-20:** Handles `GET` requests (e.g., when a user simply types the URL into their browser). It forwards the user to the physical `login.jsp` file so they can see the HTML form.

```java
23:     @Override
24:     protected void doPost(HttpServletRequest request, HttpServletResponse response)
25:             throws ServletException, IOException {
```
> **Lines 23-25:** Handles `POST` requests (e.g., when the user clicks "Submit" on the login form). 

```java
27:         String email = request.getParameter("email");
28:         String password = request.getParameter("password");
```
> **Lines 27-28:** Extracts the data the user typed into the `<input name="email">` and `<input name="password">` fields on the HTML form.

```java
30:         User user = userDAO.login(email, password);
```
> **Line 30:** Calls the `UserDAO.login()` method we analyzed earlier, passing in the user's input. It waits for the database to return the `User` object.

```java
32:         if (user != null) {
```
> **Line 32:** Checks if authentication was successful. If `user` is not null, the credentials were correct.

```java
33:             HttpSession session = request.getSession();
34:             session.setAttribute("loggedUser", user);
```
> **Lines 33-34:** Retrieves the current HTTP session (the browser's temporary memory connection with the server). It saves the `User` object inside the session under the key `"loggedUser"`. This is how the server "remembers" the user is logged in as they click through different pages.

```java
36:             String role = user.getRole();
```
> **Line 36:** Extracts the user's role (e.g., "student", "admin") from the object.

```java
38:             if ("student".equalsIgnoreCase(role)) {
39:                 response.sendRedirect(request.getContextPath() + "/student/home");
40:             } else if ("organizer".equalsIgnoreCase(role)) {
41:                 response.sendRedirect(request.getContextPath() + "/organizer/home");
42:             } else if ("admin".equalsIgnoreCase(role)) {
43:                 response.sendRedirect(request.getContextPath() + "/admin/home");
44:             } else {
45:                 response.sendRedirect(request.getContextPath() + "/login");
46:             }
```
> **Lines 38-46:** A routing switch based on the user's role. `response.sendRedirect` forces the user's browser to make a new request to the respective dashboard URL.

```java
47:         } else {
48:             // ✨ هذا الجزء الجديد
49:             request.setAttribute("error", "Invalid credentials or user is blocked");
50:             request.getRequestDispatcher("/views/login.jsp").forward(request, response);
51:         }
52:     }
53: }
```
> **Lines 47-53:** If the user was `null` (wrong password or blocked), it attaches an error message string to the `request` object (`request.setAttribute("error", ...)`). It then forwards the user back to `login.jsp`. The JSP page can read this "error" attribute and display the red text to the user.

---

## Conclusion of Data Flow
By tracing these files, we clearly see the architecture passing data:
1. **Frontend**: Sends parameters (`email`, `password`) to the backend via POST.
2. **Controller (`LoginServlet`)**: Catches the parameters, initiates the data layer.
3. **Utility (`DBConnection`)**: Opens the physical pipeline to the database.
4. **Data Access (`UserDAO`)**: Translates the parameters into a SQL query, executes it, and translates the Database Table Row back into a Java Object (`User`).
5. **Controller (`LoginServlet`)**: Receives the Java Object, stores it in the user's Session, and tells the Frontend where to go next based on the object's properties.
