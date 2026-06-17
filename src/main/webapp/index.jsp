<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.estate.util.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Estate Analytics Hub | Performance Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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
        body { background-color: var(--bg-color); color: var(--text-main); min-height: 100vh; }
        
        nav { display: flex; justify-content: space-between; align-items: center; padding: 20px 60px; border-bottom: 1px solid rgba(255,255,255,0.05); background: rgba(10, 10, 10, 0.8); backdrop-filter: blur(10px); position: sticky; top: 0; z-index: 100; }
        nav .logo { font-size: 24px; font-weight: 700; color: #FFF; text-transform: uppercase; letter-spacing: 0.5px; }
        nav .logo span { color: var(--accent-color); }
        nav .nav-links a { color: var(--text-muted); text-decoration: none; margin-left: 30px; font-weight: 500; transition: 0.3s; }
        nav .nav-links a:hover, nav .nav-links a.active { color: var(--accent-color); }
        
        .container { max-width: 1200px; margin: 60px auto; padding: 0 20px; display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 40px; }
        .panel { background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 24px; padding: 40px; backdrop-filter: blur(12px); box-shadow: 0 20px 40px rgba(0,0,0,0.5); }
        h2 { font-size: 32px; margin-bottom: 10px; color: #FFF; }
        .subtitle { color: var(--text-muted); margin-bottom: 30px; font-size: 15px; line-height: 1.5; }
        .form-group { margin-bottom: 25px; }
        label { display: block; margin-bottom: 10px; font-size: 14px; font-weight: 500; color: #FFF; text-transform: uppercase; letter-spacing: 0.5px; }
        
        input { width: 100%; padding: 14px 20px; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; color: #FFF; font-size: 16px; transition: 0.3s; }
        input:focus { border-color: var(--accent-color); outline: none; background: rgba(255,255,255,0.06); box-shadow: 0 0 15px rgba(222, 255, 154, 0.1); }
        
        /* FIX: Dropdown Elements - High-Contrast Permanent Visibility Config */
        select { 
            width: 100%; 
            padding: 14px 20px; 
            background: #141414 !important; 
            border: 1px solid rgba(255,255,255,0.1); 
            border-radius: 12px; 
            color: #F5F5F5 !important; 
            font-size: 16px; 
            transition: 0.3s;
            cursor: pointer;
        }
        select:focus { 
            border-color: var(--accent-color); 
            outline: none; 
            box-shadow: 0 0 15px rgba(222, 255, 154, 0.1); 
        }
        select option {
            background-color: #141414 !important;
            color: #F5F5F5 !important;
            padding: 14px !important;
            display: block !important;
        }

        .btn-predict { width: 100%; padding: 16px; background: var(--accent-color); color: #000; border: none; border-radius: 12px; font-size: 16px; font-weight: 700; cursor: pointer; transition: 0.2s; text-transform: uppercase; letter-spacing: 0.5px; }
        .btn-predict:hover { background: #c6eb7a; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(222, 255, 154, 0.2); }
        
        .result-pane { display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; }
        .visual-dial { width: 180px; height: 180px; border-radius: 50%; border: 4px dashed rgba(222, 255, 154, 0.2); display: flex; justify-content: center; align-items: center; margin-bottom: 30px; transition: 0.3s; }
        .visual-dial i { font-size: 54px; color: rgba(255, 255, 255, 0.15); }
        .visual-dial.active { border-color: var(--accent-color); animation: pulseGlow 1.5s infinite ease-in-out; }
        .price-output { font-size: 46px; font-weight: 700; color: var(--accent-color); margin-top: 12px; text-shadow: 0 0 20px rgba(222, 255, 154, 0.3); }
        
        @keyframes pulseGlow {
            0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(222, 255, 154, 0.3); }
            70% { transform: scale(1.03); box-shadow: 0 0 0 15px rgba(222, 255, 154, 0); }
            100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(222, 255, 154, 0); }
        }
    </style>
</head>
<body>

<nav>
    <div class="logo"><i class="fa-solid fa-chart-line" style="color: var(--accent-color); margin-right:12px;"></i>Estate<span>Analytics</span></div>
    <div class="nav-links">
        <a href="index.jsp" class="active">Predictor Engine</a>
        <% if (session != null && session.getAttribute("username") != null) { %>
            <a href="#" style="color:var(--accent-color); font-weight:700;"><i class="fa-solid fa-circle-user"></i> <%= session.getAttribute("username") %></a>
            <a href="logout.jsp" style="color:#ff6b6b; font-weight:700;">Sign Out</a>
        <% } else { %>
            <a href="login.jsp">Login Console</a>
        <% } %>
    </div>
</nav>

<div class="container">
    <div class="panel">
        <h2>Valuation Hub</h2>
        <p class="subtitle">Provide property dimensional vectors to execute real-time local parametric estimation routines.</p>
        
        <form id="predictionForm">
            <div class="form-group" style="margin-bottom: 20px;">
    <label for="city" style="display: block; margin-bottom: 8px; color: var(--text-muted); font-size: 14px; text-transform: uppercase; font-weight: 500;">Target Metro Hub City</label>
    <select name="city" id="city" required onchange="updateDistricts()" style="width: 100%; padding: 14px; background: rgba(255,255,255,0.03); border: 1px solid var(--border-color); border-radius: 12px; color: #FFF; font-size: 15px; outline: none; transition: 0.3s;">
        <option value="" disabled selected style="background:#0A0A0A;">Select a Metro Hub</option>
        <option value="Bengaluru" style="background:#0A0A0A;">Bengaluru</option>
        <option value="Mangaluru" style="background:#0A0A0A;">Mangaluru</option>
        <option value="Mysuru" style="background:#0A0A0A;">Mysuru</option>
    </select>
</div>

<div class="form-group" style="margin-bottom: 20px;">
    <label for="location" style="display: block; margin-bottom: 8px; color: var(--text-muted); font-size: 14px; text-transform: uppercase; font-weight: 500;">Target Location Micro-Market</label>
    <select name="location" id="location" required style="width: 100%; padding: 14px; background: rgba(255,255,255,0.03); border: 1px solid var(--border-color); border-radius: 12px; color: #FFF; font-size: 15px; outline: none; transition: 0.3s;">
        <option value="" disabled selected style="background:#0A0A0A;">Please select a city first</option>
    </select>
</div>

<script>
function updateDistricts() {
    const citySelect = document.getElementById("city");
    const locationSelect = document.getElementById("location");
    const selectedCity = citySelect.value;

    // Clear old choices
    locationSelect.innerHTML = '<option value="" disabled selected style="background:#0A0A0A;">Loading micro-markets...</option>';

    // Use AJAX to fetch districts matching the chosen city directly from your database entries
    fetch('GetLocationsServlet?city=' + encodeURIComponent(selectedCity))
        .then(response => response.json())
        .then(data => {
            locationSelect.innerHTML = '';
            if(data.length === 0) {
                locationSelect.innerHTML = '<option value="" disabled style="background:#0A0A0A;">No locations found for this city</option>';
                return;
            }
            data.forEach(loc => {
                let option = document.createElement("option");
                option.value = loc;
                option.textContent = loc;
                option.style.background = "#0A0A0A";
                locationSelect.appendChild(option);
            });
        })
        .catch(error => {
            console.error("Error loading location details:", error);
            locationSelect.innerHTML = '<option value="" disabled style="background:#0A0A0A;">Error compiling location records</option>';
        });
}
</script>

            <div class="form-group">
                <label>Total Dimension Area Space (Sq. Ft.)</label>
                <input type="number" name="sqft" id="sqft" min="250" max="15000" value="1200" required>
            </div>

            <div class="form-group">
                <label>BHK Layout Dimension Setup</label>
                <select name="bhk" id="bhk">
                    <option value="1">1 BHK Layout Option</option>
                    <option value="2" selected>2 BHK Apartment Matrix</option>
                    <option value="3">3 BHK Premium Setup</option>
                    <option value="4">4 BHK Executive Estate</option>
                </select>
            </div>

            <div class="form-group">
                <label>Sanitary Bathroom Units</label>
                <select name="bath" id="bath">
                    <option value="1">1 Facility Unit</option>
                    <option value="2" selected>2 Functional Bathrooms</option>
                    <option value="3">3 Deluxe Washrooms</option>
                </select>
            </div>

            <button type="button" onclick="executeModelPipeline()" class="btn-predict">Compute Valuation Response</button>
        </form>
    </div>

    <div class="panel result-pane">
        <div class="visual-dial" id="dial">
            <i class="fa-solid fa-brain" id="dialIcon"></i>
        </div>
        <h3 style="color:#FFF;">Analytical Output Window</h3>
        <div id="outputContainer" style="margin-top:15px; width: 100%;">
            <p style="color: var(--text-muted); font-size: 14px; line-height: 1.6;">System idling. Configure dimensional parameters vector parameters array and dispatch runtime query payload.</p>
        </div>
    </div>
</div>

<script>
function executeModelPipeline() {
    const dial = document.getElementById('dial');
    const dialIcon = document.getElementById('dialIcon');
    const outContainer = document.getElementById('outputContainer');

    dial.classList.add('active');
    dialIcon.className = "fa-solid fa-spinner fa-spin";
    dialIcon.style.color = "var(--accent-color)";
    outContainer.innerHTML = `<p style="color: var(--accent-color); font-weight:500;">Running calculations against multi-variable matrix...</p>`;

    const formData = new URLSearchParams();
    formData.append('location', document.getElementById('location').value);
    formData.append('sqft', document.getElementById('sqft').value);
    formData.append('bhk', document.getElementById('bhk').value);
    formData.append('bath', document.getElementById('bath').value);

    // Forces routing explicitly through context root to avoid AJAX 404 failures
    fetch('predict', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        dial.classList.remove('active');
        if(data.success) {
            dialIcon.className = "fa-solid fa-circle-check";
            dialIcon.style.color = "var(--accent-color)";
            outContainer.innerHTML = `
                <p style="color: var(--text-muted); font-size:12px; text-transform:uppercase; letter-spacing:1px; font-weight:700; margin-bottom:5px;">Estimated Valuation Matrix Result</p>
                <div class="price-output">₹ \${data.price}</div>
                <p style="color:#666; font-size:11px; margin-top:15px; line-height:1.4;">Transaction recorded successfully inside database telemetry log schema indices.</p>
            `;
        } else {
            dialIcon.className = "fa-solid fa-triangle-exclamation";
            dialIcon.style.color = "#ff6b6b";
            outContainer.innerHTML = `<p style="color: #ff6b6b; font-weight:500;">\${data.message}</p>`;
        }
    })
    .catch(() => {
        dial.classList.remove('active');
        dialIcon.className = "fa-solid fa-circle-exclamation";
        dialIcon.style.color = "#ff6b6b";
        outContainer.innerHTML = `<p style="color:#ff6b6b; font-size:14px;">Servlet connection fault. Verify server deployment target validation loops.</p>`;
    });
}
</script>
</body>
</html>