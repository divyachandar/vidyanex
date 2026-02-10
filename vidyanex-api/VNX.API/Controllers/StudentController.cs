using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using VNX.Repositories;
using CMSAPI.Models;
using VNX.DTOs;

namespace CMSAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StudentController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IMapper _mapper;

        public StudentController(AppDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        // GET: api/student
        [HttpGet]
        public async Task<ActionResult<IEnumerable<StudentDto>>> GetAll()
        {
            var students = await _context.Students.ToListAsync();
            return Ok(_mapper.Map<IEnumerable<StudentDto>>(students));
        }

        // GET: api/student/5
        [HttpGet("{id}")]
        public async Task<ActionResult<StudentDto>> GetById(int id)
        {
            var student = await _context.Students.FindAsync(id);

            if (student == null)
            {
                return NotFound();
            }

            return Ok(_mapper.Map<StudentDto>(student));
        }

        // POST: api/student
        [HttpPost]
        public async Task<ActionResult> Create(StudentDto dto)
        {
            try
            {
                var student = _mapper.Map<Student>(dto);
                
                // Ensure CreatedAt is set if not handled by DB default
                student.CreatedAt = DateTime.UtcNow;

                _context.Students.Add(student);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Student created successfully" });
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
                // If DTO doesn't have ID set, we might ignore this check or set it.
                // Assuming ID in URL is authority.
                dto.StudentId = id;
            }

            var existingStudent = await _context.Students.FindAsync(id);
            if (existingStudent == null)
            {
                return NotFound();
            }

            try
            {
                // Map properties from DTO to existing entity
                _mapper.Map(dto, existingStudent);
                
                existingStudent.UpdatedAt = DateTime.UtcNow;

                _context.Entry(existingStudent).State = EntityState.Modified;
                await _context.SaveChangesAsync();

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
            var student = await _context.Students.FindAsync(id);
            if (student == null)
            {
                return NotFound();
            }

            student.Status = status;
            student.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return Ok(new { message = "Status updated successfully" });
        }

        // DELETE: api/student/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var student = await _context.Students.FindAsync(id);
            if (student == null)
            {
                return NotFound();
            }

            try
            {
                _context.Students.Remove(student);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Student deleted successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"An error occurred: {ex.Message}" });
            }
        }
    }
}
