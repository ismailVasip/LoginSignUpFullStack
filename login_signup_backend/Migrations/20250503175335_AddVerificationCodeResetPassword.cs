using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace login_signup.Migrations
{
    /// <inheritdoc />
    public partial class AddVerificationCodeResetPassword : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_VerificationCode_AspNetUsers_UserId",
                table: "VerificationCode");

            migrationBuilder.DropPrimaryKey(
                name: "PK_VerificationCode",
                table: "VerificationCode");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "228e1c86-80f4-4318-95cd-f275b6c54ded");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "d1b836dd-a0ff-496e-8953-afca3263a16f");

            migrationBuilder.RenameTable(
                name: "VerificationCode",
                newName: "PasswordResetCodes");

            migrationBuilder.RenameIndex(
                name: "IX_VerificationCode_UserId",
                table: "PasswordResetCodes",
                newName: "IX_PasswordResetCodes_UserId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PasswordResetCodes",
                table: "PasswordResetCodes",
                column: "Id");

            // migrationBuilder.InsertData(
            //     table: "AspNetRoles",
            //     columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
            //     values: new object[,]
            //     {
            //         { "45083585-7d14-4f9c-bc45-308f9cab3bc7", null, "User", "USER" },
            //         { "b6ba5d5b-735b-48d6-8d26-f08deb8f7434", null, "Admin", "ADMIN" }
            //     });

            migrationBuilder.AddForeignKey(
                name: "FK_PasswordResetCodes_AspNetUsers_UserId",
                table: "PasswordResetCodes",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PasswordResetCodes_AspNetUsers_UserId",
                table: "PasswordResetCodes");

            migrationBuilder.DropPrimaryKey(
                name: "PK_PasswordResetCodes",
                table: "PasswordResetCodes");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "45083585-7d14-4f9c-bc45-308f9cab3bc7");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6ba5d5b-735b-48d6-8d26-f08deb8f7434");

            migrationBuilder.RenameTable(
                name: "PasswordResetCodes",
                newName: "VerificationCode");

            migrationBuilder.RenameIndex(
                name: "IX_PasswordResetCodes_UserId",
                table: "VerificationCode",
                newName: "IX_VerificationCode_UserId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_VerificationCode",
                table: "VerificationCode",
                column: "Id");

            // migrationBuilder.InsertData(
            //     table: "AspNetRoles",
            //     columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
            //     values: new object[,]
            //     {
            //         { "228e1c86-80f4-4318-95cd-f275b6c54ded", null, "User", "USER" },
            //         { "d1b836dd-a0ff-496e-8953-afca3263a16f", null, "Admin", "ADMIN" }
            //     });

            migrationBuilder.AddForeignKey(
                name: "FK_VerificationCode_AspNetUsers_UserId",
                table: "VerificationCode",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
