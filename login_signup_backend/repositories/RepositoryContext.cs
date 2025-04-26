using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using login_signup_backend.models;
using login_signup_backend.repositories.Config;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace login_signup_backend.repositories
{
    public class RepositoryContext : IdentityDbContext<User>
    {
        public RepositoryContext(DbContextOptions options) : base(options)
        {

        }
        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            //eğer birdenç çok IEntityTypeConfiguration ifaden varsa ortak bir assembly içerisinde kullanın
            builder.ApplyConfiguration(new RoleConfiguration());
        }
    }
}