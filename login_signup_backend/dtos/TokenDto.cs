using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace login_signup_backend.dtos
{
    public class TokenDto
    {
        public string AccessToken { get; init; } = string.Empty;
        public string RefreshToken { get; init; } = string.Empty;
    }
}