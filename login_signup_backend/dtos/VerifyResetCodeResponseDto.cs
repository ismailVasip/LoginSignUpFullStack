using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace login_signup_backend.dtos
{
    public class VerifyResetCodeResponseDto
    {
        public string ResetToken { get; set; } = string.Empty;
    }
}