using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace login_signup_backend.repositories.Config
{
  public class RoleConfiguration : IEntityTypeConfiguration<IdentityRole>
  {
    public void Configure(EntityTypeBuilder<IdentityRole> builder)
    {
      builder.HasData(
        new IdentityRole
        {
          Name = "Admin",
          NormalizedName = "ADMIN"
        },
        new IdentityRole
        {
          Name = "User",
          NormalizedName = "USER"
        }
      );
    }
  }
}