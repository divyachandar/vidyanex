using System.Collections.Generic;
using System.Threading.Tasks;
using CMSAPI.Models;
using VNX.Entities;

namespace VNX.Repositories
{
    public interface IStudentRepository
    {
        Task<IEnumerable<Student>> GetAllAsync();
        Task<Student> GetByIdAsync(int id);
        Task<Student> CreateAsync(Student student);
        Task UpdateAsync(Student student);
        Task DeleteAsync(Student student);
    }
}
