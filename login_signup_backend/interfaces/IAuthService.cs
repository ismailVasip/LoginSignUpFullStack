using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using login_signup_backend.dtos;
using Microsoft.AspNetCore.Identity;

namespace login_signup_backend.interfaces
{
    public interface IAuthService
    {
        Task<IdentityResult> RegisterUserAsync(UserForRegistrationDto request);
    }
}