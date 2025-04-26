using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace login_signup.Migrations
{
    /// <inheritdoc />
    public partial class AddRoleToDatabase : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[,]
                {
                    { "19646652-e735-4bdd-a2aa-9e15d658de9a", null, "Admin", "ADMIN" },
                    { "e81189d7-80d6-4eb4-937d-d6edcb3a57ab", null, "User", "USER" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "19646652-e735-4bdd-a2aa-9e15d658de9a");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e81189d7-80d6-4eb4-937d-d6edcb3a57ab");
        }
    }
}
