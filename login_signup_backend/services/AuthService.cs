using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using login_signup_backend.dtos;
using login_signup_backend.interfaces;
using login_signup_backend.models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.EntityFrameworkCore;

namespace login_signup_backend.services
{
  public class AuthService : IAuthService
  {
    private readonly IMapper _mapper;
    private readonly UserManager<User> _userManager;

    public AuthService(IMapper mapper, UserManager<User> userManager)
    {
      _mapper = mapper;
      _userManager = userManager;
    }

    public async Task<IdentityResult> RegisterUserAsync(UserForRegistrationDto request)
    {
      if (!string.IsNullOrEmpty(request.PhoneNumber))
      {
        var phoneExists = await _userManager.Users
                               .AnyAsync(u => u.PhoneNumber == request.PhoneNumber);
        if (phoneExists)
        {
          return IdentityResult.Failed(new IdentityError
          {
            Code = "DuplicatePhoneNumber",
            Description = "This phone number is already taken."
          });
        }
      }

      var user = _mapper.Map<User>(request);
      if (user == null)
      {
        return IdentityResult.Failed(new IdentityError
        {
          Code = "MappingError",
          Description = "Could not map registration data to user object."
        });
      }

      var result = await _userManager.CreateAsync(user, request.Password);
      if (result.Succeeded && request.Roles.Count != 0)
      {
        await _userManager.AddToRolesAsync(user, request.Roles);
      }
      return result;
    }
  }
}