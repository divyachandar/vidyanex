using AutoMapper;
using CMSAPI.Models;
using VNX.DTOs;
using System.Data;
using Microsoft.Data.SqlClient;

namespace VNX.API.Mappings
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Student, StudentDto>();
            CreateMap<StudentDto, Student>();
            // Note: The controller was mapping from SqlDataReader manually. 
            // AutoMapper is typically used for object-to-object mapping.
            // If we stick to SqlDataReader, AutoMapper extensions for IDataReader exist, 
            // but the user asked to replace Mapster (which was likely used for object mapping in the previous code snippet? 
            // Actually the snippet showed `student.Adapt<StudentDto>()`. 
            // The `MapStudent` helper was manual.
            
            // To fully replace manual mapping with AutoMapper for DataReader, we'd need `AutoMapper.Data` package.
            // But let's assume we want to map the Entity `Student` to `StudentDto` if we were using EF Core.
            // However, the controller uses `SqlConnection` and `SqlCommand` directly.
            // The `MapStudent` method returns a `StudentDto` manually. 
            // Then `var response=student.Adapt<StudentDto>();` used Mapster on `StudentDto`??? 
            // Wait, line 74: `var response=student.Adapt<StudentDto>();` where `student` is `StudentDto`. 
            // That's redundant. `student` is ALREADY `StudentDto` from `MapStudent`. 
            // The code was: `StudentDto student = null; ... student = MapStudent(reader); ... var response=student.Adapt<StudentDto>();`
            // This suggests the previous developer might have been confused or refactoring.
            // 
            // If I am to "Use Automapper instead of Mapster", I should replace `.Adapt<T>` calls with `_mapper.Map<T>`.
            // And if `student` is already `StudentDto`, checking line 57 `StudentDto student = null`.
            // So mapping `StudentDto` to `StudentDto` is skipping logic.
            
            // But if the Goal is to use EF Core (from my task list), then I should probably refactor the controller to use `AppDbContext` and then use AutoMapper to map `Student` Entity to `StudentDto`.
            // 
            // The user's prompt "Use the connectionstring... make changes so that Repository project builds...". 
            // AND "Use Automapper instead of Mapster".
            // 
            // If I switch to EF Core in the controller, I can use AutoMapper nicely.
            // `_context.Students.ProjectTo<StudentDto>(_mapper.ConfigurationProvider).ToList();`
            // 
            // ALL previous controller logic uses ADO.NET (SqlCommand).
            // Should I refactor it to EF Core? 
            // The user explicitly asked to "make changes so that Repository project builds code to connect to database".
            // This implies using the Repository/EF Core.
            // 
            // So my plan should be:
            // 1. Refactor `StudentController` to use `AppDbContext` (or a Repository service, but let's stick to DbContext for now or create a Repository).
            // 2. Use AutoMapper to map Entity -> DTO.
            
        }
    }
}
