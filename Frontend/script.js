
/**
 * Base URL for the backend API.
 * Update the port if the backend server uses a different one.
 */
const API_BASE = 'http://localhost:5000/api';


// ---------------- TAB SWITCHING ----------------
document.querySelectorAll('.tab-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById(btn.dataset.tab).classList.add('active');
  });
});

// ---------------- LOAD DEPARTMENTS INTO DROPDOWN ----------------
async function loadDepartments() {
  try {
    const res = await fetch(`${API_BASE}/departments`);
    const data = await res.json();
    const select = document.getElementById('departmentSelect');
    select.innerHTML = data
      .map(d => `<option value="${d.department_id}">${d.department_name}</option>`)
      .join('');
  } catch (err) {
    console.error('Failed to load Departments:', err);
  }
}
loadDepartments();

// ---------------- ADD STUDENT FORM ----------------
document.getElementById('studentForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const formData = new FormData(e.target);
  const payload = Object.fromEntries(formData.entries());

  try {
    const res = await fetch(`${API_BASE}/students`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    const data = await res.json();
    const msg = document.getElementById('studentMsg');
    if (data.success) {
      msg.textContent = ` Student added successfully! ID: ${data.student_id}`;
      msg.style.color = 'green';
      e.target.reset();
    } else {
      msg.textContent = ` Error: ${data.error}`;
      msg.style.color = 'red';
    }
  } catch (err) {
    document.getElementById('studentMsg').textContent = 'Unable to connect to the server.';
  }
});

// ---------------- ADD ADMISSION FORM ----------------
document.getElementById('admissionForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const formData = new FormData(e.target);
  const payload = Object.fromEntries(formData.entries());

  try {
    const res = await fetch(`${API_BASE}/admissions`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    const data = await res.json();
    const msg = document.getElementById('admissionMsg');
    if (data.success) {
      msg.textContent = ` Admission added successfully! ID: ${data.admission_id}`;
      msg.style.color = 'green';
      e.target.reset();
    } else {
      msg.textContent = ` Error: ${data.error}`;
      msg.style.color = 'red';
    }
  } catch (err) {
    document.getElementById('admissionMsg').textContent = 'Unable to connect to the server. Verify that the student ID is valid.';
  }
});

// ---------------- RENDER TABLE HELPER ----------------
function renderTable(container, rows) {
  if (!rows || rows.length === 0) {
    container.innerHTML = '<p>No data found.</p>';
    return;
  }
  const columns = Object.keys(rows[0]);
  const thead = `<tr>${columns.map(c => `<th>${c}</th>`).join('')}</tr>`;
  const tbody = rows.map(row =>
    `<tr>${columns.map(c => `<td>${row[c] ?? ''}</td>`).join('')}</tr>`
  ).join('');
  container.innerHTML = `<table>${thead}${tbody}</table>`;
}

// ---------------- VIEW STUDENTS ----------------
async function loadStudents() {
  const container = document.getElementById('studentsTable');
  container.innerHTML = 'Loading...';
  const res = await fetch(`${API_BASE}/students`);
  const data = await res.json();
  renderTable(container, data);
}

// ---------------- VIEW ADMISSIONS ----------------
async function loadAdmissions() {
  const container = document.getElementById('admissionsTable');
  container.innerHTML = 'Loading...';
  const res = await fetch(`${API_BASE}/admissions`);
  const data = await res.json();
  renderTable(container, data);
}

// ---------------- REPORTS / QUERIES ----------------
async function runQuery(endpoint, title) {
  document.getElementById('reportTitle').textContent = title;
  const container = document.getElementById('reportResult');
  container.innerHTML = 'Loading...';

  const res = await fetch(`${API_BASE}/queries/${endpoint}`);
  const data = await res.json();

  // Some queries return a single object (e.g., average GPA), while others return an array.
  const rows = Array.isArray(data) ? data : [data];
  renderTable(container, rows);
}

// Load students and admissions when the page loads.
loadStudents();
loadAdmissions();
