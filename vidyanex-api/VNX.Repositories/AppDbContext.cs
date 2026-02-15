using Microsoft.EntityFrameworkCore;
using CMSAPI.Models;

namespace VNX.Repositories
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public virtual DbSet<AdmissionApplication> AdmissionApplications { get; set; }
        public virtual DbSet<AdmissionDocument> AdmissionDocuments { get; set; }
        public virtual DbSet<AdmissionStatusHistory> AdmissionStatusHistories { get; set; }
        public virtual DbSet<Book> Books { get; set; }
        public virtual DbSet<BookIssue> BookIssues { get; set; }
        public virtual DbSet<Campus> Campuses { get; set; }
        public virtual DbSet<Course> Courses { get; set; }
        public virtual DbSet<Department> Departments { get; set; }
        public virtual DbSet<Exam> Exams { get; set; }
        public virtual DbSet<FeeStructure> FeeStructures { get; set; }
        public virtual DbSet<InstitutionSetting> InstitutionSettings { get; set; }
        public virtual DbSet<NotificationSetting> NotificationSettings { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<SecuritySetting> SecuritySettings { get; set; }
        public virtual DbSet<StaffProfile> StaffProfiles { get; set; }
        public virtual DbSet<Student> Students { get; set; }
        public virtual DbSet<StudentProfile> StudentProfiles { get; set; }
        public virtual DbSet<StudentTransportAssignment> StudentTransportAssignments { get; set; }
        public virtual DbSet<Subject> Subjects { get; set; }
        public virtual DbSet<TransportRoute> TransportRoutes { get; set; }
        public virtual DbSet<TransportRouteStop> TransportRouteStops { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<UserProfile> UserProfiles { get; set; }
        public virtual DbSet<VwStudentDistribution> VwStudentDistributions { get; set; }
        public virtual DbSet<VwStudentTransport> VwStudentTransports { get; set; }
        public virtual DbSet<VwTransportRoute> VwTransportRoutes { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AdmissionApplication>().HasKey(e => e.ApplicationId);
            modelBuilder.Entity<AdmissionDocument>().HasKey(e => e.DocumentId);
            modelBuilder.Entity<AdmissionStatusHistory>().HasKey(e => e.HistoryId);

            modelBuilder.Entity<VwStudentDistribution>().HasNoKey().ToView("vw_StudentDistribution");
            modelBuilder.Entity<VwStudentTransport>().HasNoKey().ToView("vw_StudentTransport");
            modelBuilder.Entity<VwTransportRoute>().HasNoKey().ToView("vw_TransportRoute");
        }
    }
}
