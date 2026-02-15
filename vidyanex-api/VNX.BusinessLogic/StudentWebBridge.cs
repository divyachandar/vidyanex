using System.Collections.Generic;
using System.Threading.Tasks;
using AutoMapper;
using VNX.Repositories;
using CMSAPI.Models;
using VNX.Entities;
using System;

namespace VNX.BusinessLogic
{
    public class StudentWebBridge : IStudentWebBridge
    {
        private readonly IStudentRepository _studentRepository;
        private readonly IMapper _mapper;

        public StudentWebBridge(IStudentRepository studentRepository, IMapper mapper)
        {
            _studentRepository = studentRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<StudentDto>> GetAllStudentsAsync()
        {
            var students = await _studentRepository.GetAllAsync();
            return _mapper.Map<IEnumerable<StudentDto>>(students);
        }

        public async Task<StudentDto> GetStudentByIdAsync(int id)
        {
            var student = await _studentRepository.GetByIdAsync(id);
            return _mapper.Map<StudentDto>(student);
        }

        public async Task<StudentDto> CreateStudentAsync(StudentDto studentDto)
        {
            var student = _mapper.Map<Student>(studentDto);
            student.CreatedAt = DateTime.UtcNow;
            var createdStudent = await _studentRepository.CreateAsync(student);
            return _mapper.Map<StudentDto>(createdStudent);
        }

        public async Task UpdateStudentAsync(int id, StudentDto studentDto)
        {
            var existingStudent = await _studentRepository.GetByIdAsync(id);
            if (existingStudent != null)
            {
                _mapper.Map(studentDto, existingStudent);
                existingStudent.UpdatedAt = DateTime.UtcNow;
                await _studentRepository.UpdateAsync(existingStudent);
            }
        }

        public async Task UpdateStudentStatusAsync(int id, string status)
        {
            var existingStudent = await _studentRepository.GetByIdAsync(id);
            if (existingStudent != null)
            {
                existingStudent.Status = status;
                existingStudent.UpdatedAt = DateTime.UtcNow;
                await _studentRepository.UpdateAsync(existingStudent);
            }
        }

        public async Task DeleteStudentAsync(int id)
        {
            var student = await _studentRepository.GetByIdAsync(id);
            if (student != null)
            {
                await _studentRepository.DeleteAsync(student);
            }
        }
    }
}
