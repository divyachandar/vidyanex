using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using VNX.BusinessLogic;
using CMSAPI.Models;
using Microsoft.EntityFrameworkCore;
using VNX.Repositories;

namespace CMSAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StudentController : ControllerBase
    {
        private readonly IStudentWebBridge _studentWebBridge;

        public StudentController(IStudentWebBridge studentWebBridge)
        {
            _studentWebBridge = studentWebBridge;
        }

        // GET: api/student
        [HttpGet]
        public async Task<ActionResult<IEnumerable<StudentDto>>> GetAll()
        {
            var students = await _studentWebBridge.GetAllStudentsAsync();
            return Ok(students);
        }

        // GET: api/student/5
        [HttpGet("{id}")]
        public async Task<ActionResult<StudentDto>> GetById(int id)
        {
            var student = await _studentWebBridge.GetStudentByIdAsync(id);

            if (student == null)
            {
                return NotFound();
            }

            return Ok(student);
        }

        // POST: api/student
        [HttpPost]
        public async Task<ActionResult> Create(StudentDto dto)
        {
            try
            {
                var createdStudent = await _studentWebBridge.CreateStudentAsync(dto);
                return Ok(new { message = "Student created successfully", student = createdStudent });
            }
            catch (DbUpdateException ex)
            {
                 // Check for unique constraint violation (SQL Server error 2601 or 2627)
                 if (ex.InnerException is Microsoft.Data.SqlClient.SqlException sqlEx && 
                     (sqlEx.Number == 2601 || sqlEx.Number == 2627))
                 {
                    return Conflict(new { message = "A student with this Student Code or Email already exists." });
                 }
                 return StatusCode(500, new { message = $"An error occurred: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"An error occurred: {ex.Message}" });
            }
        }

        // PUT: api/student/5
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, StudentDto dto)
        {
            if (id != dto.StudentId)
            {
                dto.StudentId = id;
            }

            try
            {
                await _studentWebBridge.UpdateStudentAsync(id, dto);
                return Ok(new { message = "Student updated successfully" });
            }
            catch (DbUpdateException ex)
            {
                if (ex.InnerException is Microsoft.Data.SqlClient.SqlException sqlEx && 
                    (sqlEx.Number == 2601 || sqlEx.Number == 2627))
                {
                   return Conflict(new { message = "A student with this Email already exists." });
                }
                return StatusCode(500, new { message = $"An error occurred: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"An error occurred: {ex.Message}" });
            }
        }

        // PATCH: api/student/status/5
        [HttpPatch("status/{id}")]
        public async Task<IActionResult> UpdateStatus(int id, [FromQuery] string status)
        {
            try
            {
                await _studentWebBridge.UpdateStudentStatusAsync(id, status);
                return Ok(new { message = "Status updated successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"An error occurred: {ex.Message}" });
            }
        }

        // DELETE: api/student/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                await _studentWebBridge.DeleteStudentAsync(id);
                return Ok(new { message = "Student deleted successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"An error occurred: {ex.Message}" });
            }
        }
    }
}
