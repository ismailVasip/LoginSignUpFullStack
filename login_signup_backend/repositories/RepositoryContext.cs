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

        public DbSet<VerificationCode> PasswordResetCodes { get; set; }
        
        protected override void OnModelCreating(ModelBuilder builder)
        {

            // Provides configuration of identity tables.
            base.OnModelCreating(builder);

            //eğer birdenç çok IEntityTypeConfiguration ifaden varsa ortak bir assembly içerisinde kullanın
            builder.ApplyConfiguration(new RoleConfiguration());

            builder.Entity<VerificationCode>(entity =>
        {
            entity.HasOne(d => d.User)
                .WithMany(p => p.PasswordResetCodes)
                .HasForeignKey(d => d.UserId)
                // Cascade: Kullanıcı silinirse ilişkili tüm kodlar da silinir. DİKKATLİ KULLANIN!
                // Restrict: İlişkili kod varken kullanıcı silinemez (hata verir). Genellikle daha güvenlidir.
                // SetNull: Kullanıcı silinirse kodların UserId'si NULL yapılır (UserId nullable olmalı).
                .OnDelete(DeleteBehavior.Cascade); 
        });
        }
    }
}