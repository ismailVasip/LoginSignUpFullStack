using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using login_signup_backend.common.enums;

namespace login_signup_backend.dtos
{
    public class UserForRegistrationDto
    {
        [Required(ErrorMessage = "The FullName field is required")]
        [MinLength(5, ErrorMessage = "The FullName must be at least 5 characters long")]
        [MaxLength(50, ErrorMessage = "The FullName must not exceed 50 characters")]
        public string FullName { get; init; } = string.Empty;

        [Required(ErrorMessage = "The Email field is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        public string Email { get; init; } = string.Empty;

        [Required(ErrorMessage = "The Password field is required")]
        public string Password { get; init; } = string.Empty;

        [Required(ErrorMessage = "Confirm new password is required!")]
        [Compare("Password", ErrorMessage = "Passwords do not match!")]
        public string ConfirmPassword { get; init; } = string.Empty;
        public Gender Gender { get; init; } = Gender.Unspecified;

        [Required(ErrorMessage = "The PhoneNumber field is required")]
        [RegularExpression(@"^\+[1-9]\d{1,14}$",
        ErrorMessage = "Invalid phone number format. Please use a valid international format (e.g., +1-123-456-7890)")]
        public string PhoneNumber { get; init; } = string.Empty;

        [Required(ErrorMessage = "Date of birth is required!")]
        [DataType(DataType.Date)]
        [CustomValidation(typeof(DateValidation), "ValidateAge")]
        public DateTime DateOfBirth { get; init; } = DateTime.Now;

        public ICollection<string> Roles { get; init; } = [];
    }
    public static class DateValidation
    {
        public static ValidationResult? ValidateAge(DateTime? dateOfBirth, ValidationContext context)
        {
            if (!dateOfBirth.HasValue)
                return ValidationResult.Success; // for update profile - nonnecessary for current project

            var age = DateTime.Now.Year - dateOfBirth.Value.Year;
            if (dateOfBirth.Value > DateTime.Now.AddYears(-age)) age--;

            return age >= 16
                ? ValidationResult.Success
                : new ValidationResult("You must be at least 16 years old to register!");
        }
    }
}