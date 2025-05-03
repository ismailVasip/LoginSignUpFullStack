using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using login_signup_backend.dtos;
using login_signup_backend.interfaces;
using login_signup_backend.repositories;
using Microsoft.EntityFrameworkCore;

namespace login_signup_backend.services
{
    public class UserService : IUserService
    {
        private readonly RepositoryContext _context;
        private readonly IMapper _mapper;

        public UserService(RepositoryContext repositoryContext, IMapper mapper)
        {
            _context = repositoryContext;
            _mapper = mapper;
        }

        public async Task<List<ReturnUser>> GetAllUsersAsync()
        {
            var usersFromContext = await _context.Users.ToListAsync();
            
            return   _mapper.Map<List<ReturnUser>>(usersFromContext);
        }
    }
}