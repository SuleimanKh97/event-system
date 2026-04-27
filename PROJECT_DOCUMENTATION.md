# Campus Event System - Comprehensive Project Documentation

This documentation provides an exhaustive, detailed breakdown of the Campus Event System project. It covers the system's architecture, design patterns, class structures, method functions, and the exact flow of data between the frontend, backend, and database.

---

## 1. Architectural Overview & Design Patterns

The project follows a standard **Java EE web application architecture** utilizing Servlets, JSP (JavaServer Pages), and JDBC for database interaction. It operates on a robust three-tier architecture:

1. **Presentation Layer (Frontend)**: JSP files and CSS for the UI.
2. **Business/Controller Layer (Backend)**: Java Servlets handling HTTP requests and business logic.
3. **Data Access Layer (Database)**: DAO (Data Access Object) classes and JDBC connecting to MySQL.

### Design Patterns Utilized:

1. **MVC (Model-View-Controller) Pattern**:
   - **Model**: Java Beans (e.g., `Event.java`, `User.java`) that hold the data state, and DAO classes handling data retrieval.
   - **View**: JSP files (`login.jsp`, `home.jsp`, etc.) that render the user interface.
   - **Controller**: Java Servlets (`LoginServlet.java`, `AddEventServlet.java`, etc.) that act as an intermediary, receiving requests from the View, interacting with the Model, and returning the appropriate View.

2. **DAO (Data Access Object) Pattern**:
   - All database interaction logic is decoupled from the main application logic and stored in dedicated DAO classes (`UserDAO`, `EventDAO`, `ReservationDAO`, `RatingDAO`). This ensures that if the database changes, only the DAOs need updates, adhering to the Single Responsibility Principle.

3. **Singleton/Factory Method Pattern (Utility Level)**:
   - `DBConnection.java` utilizes a static factory method `getConnection()` to yield database connections without requiring the instantiation of a database manager object everywhere. 

4. **Object-Oriented Inheritance Pattern**:
   - The project uses inheritance for Event types. The base `Event.java` class is extended by specific event types like `SeminarEvent.java`, `WorkshopEvent.java`, `ClubSocialEvent.java`, configuring default properties natively inside their constructors.

---

## 2. Global Data Flow (Frontend $\rightarrow$ Backend $\rightarrow$ Database)

How data passes through the system:
1. **User Action**: The user submits an HTML form on a JSP page (e.g., entering email and password in `login.jsp`).
2. **HTTP Request**: The form sends a `POST` or `GET` request to a specific mapped URL (e.g., `/login`).
3. **Controller Intercept**: The Application Server (Tomcat) routes the request to the matching Servlet (e.g., `LoginServlet`).
4. **Data Extraction**: The Servlet uses `request.getParameter("key")` to extract user inputs.
5. **Business Logic & DAO Delegation**: The Servlet creates or utilizes a Model object and passes the parameters to a method inside a DAO class (e.g., `userDAO.login(email, password)`).
6. **Database Execution**: The DAO establishes a connection using `DBConnection`, prepares a SQL query (`PreparedStatement`), and executes it against the MySQL Database.
7. **Result Mapping**: The Database returns a `ResultSet`. The DAO extracts this, maps it to a Java Model object (e.g., `User` object), and returns it to the Servlet.
8. **Session & Routing**: The Servlet receives the object. If successful, it stores user data in the `HttpSession` (`session.setAttribute("loggedUser", user)`) to maintain state. It then uses `response.sendRedirect()` or `request.getRequestDispatcher().forward()` to send the user to the next View.
9. **View Rendering**: The final JSP reads session/request attributes using EL (Expression Language) like `${loggedUser.fullName}` and renders the HTML for the user.

---

## 3. Class and Method Documentation

### A. Utility Classes
**`com.campus.eventsystem.util.DBConnection`**
- **Purpose**: Establishes the connection to the MySQL database.
- **Methods**:
  - `public static Connection getConnection()`: Uses `DriverManager.getConnection` with the predefined `URL`, `USER`, and `PASSWORD` to return an active `java.sql.Connection`. Includes try-catch error handling for `ClassNotFoundException` and `SQLException`.

### B. Model Classes (Data Transfer Objects)
**`com.campus.eventsystem.model.User`**
- **Purpose**: Represents a user in the system. Maps to the `users` database table.
- **Fields**: `id`, `fullName`, `email`, `password`, `role`, `faculty`, `department`, `admissionYear`, `blocked`.
- **Methods**: Standard Getters and Setters for all fields.

**`com.campus.eventsystem.model.Event`**
- **Purpose**: Represents an event. Maps to the `events` database table.
- **Fields**: `id`, `title`, `description`, `date`, `capacity`, `type`, `organizerId`, `organizerName`, `departmentClub`, `eventTime`, `location`, `category`, `imagePath`, `registrationStatus`, `eventStatus`.
- **Inheritance**: Subclasses like `SeminarEvent`, `WorkshopEvent`, `ClubSocialEvent` extend this class and set a default `type` in their constructor (e.g., `setType("Seminar")`).

### C. Data Access Objects (DAOs)

#### **`UserDAO`**
Handles all CRUD operations for users.
- **`login(String email, String password)`**: 
  - *Function*: Authenticates users. Executes `SELECT * FROM users WHERE email=? AND password=?`. 
  - *Return*: `User` object if found and `blocked` is false. Returns `null` if blocked or invalid.
- **`registerUser(User user)`**:
  - *Function*: Creates a new user. Executes `INSERT INTO users (...) VALUES (...)`.
- **`getAllUsers()`**, **`getUserById(int id)`**:
  - *Function*: Fetches user records mapping them into `User` objects.
- **`updateUserRole(int id, String role)`**, **`toggleUserBlock(int userId)`**, **`deleteUser(int id)`**:
  - *Function*: Administrative functions altering the state of a user in the database.

#### **`EventDAO`**
Handles all event-related operations.
- **`mapEvent(ResultSet rs)`**: A private helper method centralizing the conversion of a database row into an `Event` object.
- **`addEvent(Event event)`**: Executes an `INSERT` statement to save an event. Defaults `registration_status` to "OPEN" and `event_status` to "UPCOMING".
- **`getAllEvents()`**, **`getEventById(int id)`**: Retrieves events from the database.
- **`updateEvent(Event event)`**: Updates event metadata.
- **`deleteEvent(int id)`**: Deletes an event by ID.
- **`reserveEvent(int userId, int eventId)`** *(Crucial Method)*:
  - *Function*: Uses transaction management (`conn.setAutoCommit(false)`) and Row Locking (`FOR UPDATE`) to handle concurrency.
  - *Logic*: Checks if capacity > 0, registration is "OPEN", and event is "UPCOMING". If true, it decrements capacity (`UPDATE events SET capacity = capacity - 1`), adds the reservation (`INSERT INTO reservations`), and commits. Rolls back if any check fails.
- **`expireOldEvents()`**: Runs a cron-like query mapping past events (`event_date < CURDATE()`) to 'EXPIRED'.

### D. Controllers (Servlets)

#### **Authentication Servlets**
- **`LoginServlet`**:
  - *doGet*: Forwards the user to `login.jsp`.
  - *doPost*: Extracts `email` and `password`, calls `userDAO.login()`. If successful, saves the `User` object into `HttpSession` and redirects based on the `role` (`/student/home`, `/admin/home`, etc.). If failed, attaches an error message and forwards back to `login.jsp`.
- **`RegisterServlet`**:
  - *doPost*: Grabs form fields, builds a `User` object, checks if the email exists, and calls `userDAO.registerUser()`. Redirects to login on success.
- **`LogoutServlet`**:
  - *doGet*: Calls `request.getSession().invalidate()` clearing all session data, preventing authorized access back, then redirects to `/login`.

#### **Event Management Servlets**
- **`AddEventServlet`**:
  - *doPost*: Extracts form properties. Utilizes the current logged-in Organizer's ID from the Session. Passes the built `Event` to `EventDAO.addEvent()`.
- **`EditEventServlet`**:
  - *doGet*: Fetches `Event` by ID and forwards to `edit-event.jsp`.
  - *doPost*: Collects updated form fields, updates the `Event` object, and saves it to the database via `EventDAO`.
- **`DeleteEventServlet`**:
  - *doGet*: Extracts event ID from the query string and invokes `EventDAO.deleteEvent()`. Redirects back to the event listing.
- **`ReserveServlet`**:
  - *doPost*: Gets event ID and user ID. Calls `eventDAO.reserveEvent()`. Handles the boolean response providing success/error feedback attributes to the view.

#### **Admin & Management Servlets**
- **`AdminUsersServlet`**: Calls `userDAO.getAllUsers()` and forwards the list to `users.jsp` for the admin to view.
- **`BlockUserServlet`**: Invokes `userDAO.toggleUserBlock(id)`.

---

## 4. Relationship Flow: A Step-By-Step Example (User Login)

1. **Frontend**: The user accesses `http://localhost:8080/event-system/login`. Tomcat routes this to `LoginServlet.doGet()`. The Servlet forwards the user to `/views/login.jsp`.
2. **User Input**: User fills `<form action="login" method="POST">` with `email` and `password`. The form is submitted.
3. **Servlet Capture**: Tomcat triggers `LoginServlet.doPost()`. The Servlet reads the parameters using `request.getParameter()`.
4. **DAO Execution**: `LoginServlet` instantiates `UserDAO` and calls `login(email, password)`.
5. **Database Interaction**: `UserDAO` asks `DBConnection` for a connection, prepares the SQL (`SELECT * FROM users WHERE email=? AND password=?`), and executes it.
6. **Object Instantiation**: `UserDAO` takes the `ResultSet`, instantiates a `new User()`, populates its setters, and returns it to `LoginServlet`.
7. **Session Setup**: `LoginServlet` confirms the `User` is not null. It opens a session: `HttpSession session = request.getSession();` and stores the object: `session.setAttribute("loggedUser", user)`.
8. **Redirect**: Depending on `user.getRole()`, `LoginServlet` sends an HTTP 302 Redirect to `/student/home` or `/organizer/home`.
9. **Access Control**: On the destination page (e.g., `student-home.jsp`), EL (`${loggedUser.fullName}`) is used. Because the object is in the session, the JSP renders "Welcome, [Name]".

## Summary
The Campus Event System leverages classic Java EE design paradigms. By explicitly decoupling Database queries (DAOs), Application Logic (Servlets), and Presentational markup (JSP/CSS), the system ensures scalability, high cohesion, and strict adherence to the Single Responsibility Principle. Data passing is entirely facilitated via HTTP Requests parameters inbound, and Java Object Attributes injected into scopes (Request/Session) outbound.
