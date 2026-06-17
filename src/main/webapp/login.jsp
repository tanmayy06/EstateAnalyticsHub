<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Estate Analytics | Login Console</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #0A0A0A;
            --card-bg: rgba(20, 20, 20, 0.7);
            --accent-color: #DEFF9A;
            --text-main: #F5F5F5;
            --text-muted: #BBB;
            --border-color: rgba(222, 255, 154, 0.15);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background-color: var(--bg-color); color: var(--text-main); min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .login-panel { background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 24px; padding: 40px; width: 100%; max-width: 420px; backdrop-filter: blur(12px); box-shadow: 0 20px 40px rgba(0,0,0,0.5); }
        h2 { font-size: 28px; margin-bottom: 8px; color: #FFF; text-align: center; }
        .subtitle { color: var(--text-muted); margin-bottom: 30px; font-size: 14px; text-align: center; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-size: 12px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }
        input { width: 100%; padding: 14px 20px; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; color: #FFF; font-size: 16px; transition: 0.3s; }
        input:focus { border-color: var(--accent-color); outline: none; background: rgba(255,255,255,0.06); }
        .btn-login { width: 100%; padding: 16px; background: var(--accent-color); color: #000; border: none; border-radius: 12px; font-size: 16px; font-weight: 700; cursor: pointer; transition: 0.2s; text-transform: uppercase; margin-top: 10px; }
        .btn-login:hover { background: #c6eb7a; transform: translateY(-1px); }
        .footer-link { margin-top: 25px; text-align: center; font-size: 14px; color: var(--text-muted); }
        .footer-link a { color: var(--accent-color); text-decoration: none; font-weight: 500; }
        .alert { padding: 12px; border-radius: 8px; font-size: 13px; margin-bottom: 20px; text-align: center; }
        .alert-success { background: rgba(222, 255, 154, 0.1); border: 1px solid var(--accent-color); color: var(--accent-color); }
        .alert-danger { background: rgba(255, 107, 107, 0.1); border: 1px solid #ff6b6b; color: #ff6b6b; }
    </style>
</head>
<body>

<div class="login-panel">
    <h2>Access Terminal</h2>
    <p class="subtitle">Authenticate profile credentials to unlock core computation clusters.</p>
    
    <% if(request.getParameter("success") != null) { %>
        <div class="alert alert-success"><%= request.getParameter("success") %></div>
    <% } %>
    <% if(request.getParameter("error") != null) { %>
        <div class="alert alert-danger"><%= request.getParameter("error") %></div>
    <% } %>

    <form action="login" method="POST">
        <div class="form-group">
            <label>Email Handle</label>
            <input type="email" name="email" placeholder="name@domain.com" required>
        </div>
        <div class="form-group">
            <label>Security Key</label>
            <input type="password" name="password" placeholder="••••••••" required>
        </div>
        <button type="submit" class="btn-login">Open Session</button>
    </form>
    
    <div class="footer-link">
        New analyst? <a href="register.jsp">Create an Account here</a>
    </div>
</div>

</body>
</html>