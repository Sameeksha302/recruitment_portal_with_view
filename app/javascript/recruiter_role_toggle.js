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
  
document.addEventListener('DOMContentLoaded', () => {
  const roleSelect = document.getElementById('role-select');
  const companyNameField = document.getElementById('company-name-field');

  // Function to toggle company name field
  const toggleCompanyNameField = () => {
    if (roleSelect.value === 'Recruiter') {
      companyNameField.classList.remove('d-none');
      companyNameField.classList.add('d-block');
    } else {
      companyNameField.classList.remove('d-block');
      companyNameField.classList.add('d-none');
    }
  };

  // Add event listener
  roleSelect.addEventListener('change', toggleCompanyNameField);
  toggleCompanyNameField(); // Initial check
});
