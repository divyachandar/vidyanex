using System.Collections.Generic;
using System.Threading.Tasks;
using VNX.Entities;
using CMSAPI.Models;

namespace VNX.BusinessLogic
{
    public interface IStudentWebBridge
    {
        Task<IEnumerable<StudentDto>> GetAllStudentsAsync();
        Task<StudentDto> GetStudentByIdAsync(int id);
        Task<StudentDto> CreateStudentAsync(StudentDto studentDto);
        Task UpdateStudentAsync(int id, StudentDto studentDto);
        Task UpdateStudentStatusAsync(int id, string status);
        Task DeleteStudentAsync(int id);
    }
}
