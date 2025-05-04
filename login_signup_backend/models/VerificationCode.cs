using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace login_signup_backend.models
{
    public class VerificationCode
    {
        public string Id { get; set; } = string.Empty;
        public string UserId { get; set; } = string.Empty; // Foreign Key
        public string Code { get; set; } = string.Empty;
        public DateTime ExpiryTimeUtc { get; set; } = DateTime.UtcNow;
         public bool IsUsed { get; set; } = false;

         // --- Navigation Property ---
         public virtual User? User { get; set; }
    }
}