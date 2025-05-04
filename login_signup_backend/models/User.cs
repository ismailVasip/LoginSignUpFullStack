using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using login_signup_backend.common.enums;
using Microsoft.AspNetCore.Identity;

namespace login_signup_backend.models
{
    public class User:IdentityUser
    {
        public string FullName { get; set; } = string.Empty;
        public Gender Gender { get; set;} = Gender.Unspecified;
        public DateTime DateOfBirth { get; set; } = DateTime.Now;
        public string RefreshToken { get; set; } = string.Empty;
        public DateTime RefreshTokenExpiryTime { get; set; }

        // --- Navigation Property ---
        public virtual ICollection<VerificationCode> PasswordResetCodes { get; set; } = new List<VerificationCode>();
    }
}