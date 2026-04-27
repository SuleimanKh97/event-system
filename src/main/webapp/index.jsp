<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Campus Event System - Welcome</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary: #6366f1;
                --primary-dark: #4f46e5;
                --secondary: #ec4899;
                --accent: #8b5cf6;
                --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
                --glass-bg: rgba(255, 255, 255, 0.03);
                --glass-border: rgba(255, 255, 255, 0.1);
                --text-main: #f8fafc;
                --text-muted: #94a3b8;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Outfit', sans-serif;
                background: var(--bg-gradient);
                background-attachment: fixed;
                color: var(--text-main);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 2rem;
                overflow-x: hidden;
            }

            /* Decorative background elements */
            .blob {
                position: absolute;
                width: 500px;
                height: 500px;
                background: radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, rgba(99, 102, 241, 0) 70%);
                filter: blur(40px);
                z-index: -1;
                animation: move 20s infinite alternate;
            }

            .blob-1 {
                top: -100px;
                left: -100px;
            }

            .blob-2 {
                bottom: -100px;
                right: -100px;
                background: radial-gradient(circle, rgba(236, 72, 153, 0.1) 0%, rgba(236, 72, 153, 0) 70%);
            }

            @keyframes move {
                from {
                    transform: translate(0, 0);
                }

                to {
                    transform: translate(100px, 50px);
                }
            }

            .container {
                max-width: 800px;
                width: 100%;
                background: var(--glass-bg);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid var(--glass-border);
                border-radius: 2rem;
                padding: 4rem 2rem;
                text-align: center;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
                animation: fadeIn 1s ease-out;
                position: relative;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            h1 {
                font-size: clamp(2.5rem, 8vw, 4rem);
                font-weight: 800;
                margin-bottom: 1.5rem;
                background: linear-gradient(to right, #fff, #94a3b8);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                line-height: 1.1;
            }

            h2 {
                font-size: 1.25rem;
                font-weight: 400;
                color: var(--secondary);
                text-transform: uppercase;
                letter-spacing: 0.2rem;
                margin-bottom: 2.5rem;
            }

            .student-list {
                list-style: none;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 1rem;
                margin-bottom: 3rem;
                perspective: 1000px;
            }

            .student-list li {
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid var(--glass-border);
                padding: 1.25rem;
                border-radius: 1rem;
                font-size: 1.1rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                display: flex;
                flex-direction: column;
                gap: 0.25rem;
                cursor: default;
            }

            .student-list li:hover {
                background: rgba(255, 255, 255, 0.08);
                transform: translateY(-5px) scale(1.02);
                border-color: var(--primary);
                box-shadow: 0 10px 20px -10px rgba(99, 102, 241, 0.3);
            }

            .student-name {
                font-weight: 600;
                color: var(--text-main);
            }

            .student-id {
                font-size: 0.9rem;
                color: var(--text-muted);
                font-family: monospace;
            }

            .login-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 1.25rem 3rem;
                font-size: 1.1rem;
                font-weight: 600;
                color: white;
                text-decoration: none;
                background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
                border-radius: 100px;
                transition: all 0.3s ease;
                box-shadow: 0 10px 20px -5px rgba(99, 102, 241, 0.5);
                border: none;
                position: relative;
                overflow: hidden;
            }

            .login-btn::after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, rgba(255, 255, 255, 0.2) 0%, transparent 100%);
                opacity: 0;
                transition: 0.3s;
            }

            .login-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 15px 30px -5px rgba(99, 102, 241, 0.6);
                padding-right: 3.5rem;
            }

            .login-btn:hover::after {
                opacity: 1;
            }

            .login-btn::before {
                content: '→';
                position: absolute;
                right: 1.5rem;
                opacity: 0;
                transform: translateX(-10px);
                transition: all 0.3s ease;
            }

            .login-btn:hover::before {
                opacity: 1;
                transform: translateX(0);
            }

            @media (max-width: 640px) {
                .container {
                    padding: 3rem 1.5rem;
                    margin: 1rem;
                }

                h1 {
                    font-size: 2.5rem;
                }

                .student-list {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>

    <body>
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>

        <main class="container">
            <h1>Campus Event System</h1>

            <h2>Project Team</h2>

            <ul class="student-list">
                <li>
                    <span class="student-name">Dana Mohammed ali magableh</span>
                    <span class="student-id">#162972</span>
                </li>
                <li>
                    <span class="student-name">Dania Aref Awwad Alzboon</span>
                    <span class="student-id">#154677</span>
                </li>
                <li>
                    <span class="student-name">Dala’ Ibrahim Awwad Al-qudah</span>
                    <span class="student-id">#158307</span>
                </li>
                <li>
                    <span class="student-name">Dana Jawdat Nimri</span>
                    <span class="student-id">#157993</span>
                </li>
            </ul>

            <div style="display:flex;gap:1rem;justify-content:center;flex-wrap:wrap;">
                <a href="${pageContext.request.contextPath}/events" class="login-btn"
                    style="background:transparent;border:2px solid var(--primary);box-shadow:none;">Explore Events</a>
                <a href="views/login.jsp" class="login-btn">Sign In</a>
            </div>
        </main>
    </body>

    </html>