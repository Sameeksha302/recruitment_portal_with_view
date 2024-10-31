// // app/javascript/packs/recruiter_role_toggle.js
// document.addEventListener("DOMContentLoaded", function() {
//     const roleSelect = document.getElementById('role-select');
//     const companyNameField = document.getElementById('company-name-field');
  
//     function toggleCompanyNameField() {
//       if (roleSelect.value === 'Recruiter') {
//         companyNameField.classList.remove('d-none');  
//       } else {
//         companyNameField.classList.add('d-none');  
//       }
//     }
  
//     toggleCompanyNameField();
//     roleSelect.addEventListener('change', toggleCompanyNameField);
//   });
  
// JavaScript to toggle the visibility of the Company Name field
document.addEventListener("DOMContentLoaded", function() {
  const roleSelect = document.getElementById('role-select');
  const companyNameField = document.getElementById('company-name-field');
  const companyIdField = document.getElementById('company-id-field');

  // Function to toggle visibility based on role selection
  function toggleCompanyFields() {
    if (roleSelect.value === 'Recruiter') {
      companyNameField.classList.remove('d-none');
      companyIdField.classList.remove('d-none');
    } else {
      companyNameField.classList.add('d-none');
      companyIdField.classList.add('d-none');
    }
  }

  // Initial check and event listener for role change
  toggleCompanyFields(); // Initial check in case of page reload
  roleSelect.addEventListener('change', toggleCompanyFields);
});

