using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace login_signup.Migrations
{
    /// <inheritdoc />
    public partial class mailsettingsadded : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3a02ed5a-6856-4c78-8366-9d986aef5f64");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "84eca890-8d9e-4095-8d91-593fcfa3fa8a");

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[,]
                {
                    { "6d3ac4fb-30ee-4da0-ad3d-38b86c101486", null, "Admin", "ADMIN" },
                    { "b364c104-c2b2-4ddc-8b1c-f6e19e6196d5", null, "User", "USER" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6d3ac4fb-30ee-4da0-ad3d-38b86c101486");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b364c104-c2b2-4ddc-8b1c-f6e19e6196d5");

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[,]
                {
                    { "3a02ed5a-6856-4c78-8366-9d986aef5f64", null, "Admin", "ADMIN" },
                    { "84eca890-8d9e-4095-8d91-593fcfa3fa8a", null, "User", "USER" }
                });
        }
    }
}
