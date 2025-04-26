using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace login_signup_backend.repositories
{
    public class RepositoryContext:DbContext
    {
        public RepositoryContext(DbContextOptions options) : base(options)
        {
            
        }
    }
}