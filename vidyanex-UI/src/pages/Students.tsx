import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Button,
  Chip,
  IconButton,
  TextField,
  InputAdornment,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Grid,
  Card,
  CardContent,
  CircularProgress,
  Alert,
  ButtonGroup,
} from '@mui/material';
import {
  Add,
  Edit,
  Delete,
  Search,
  Visibility,
  ViewList,
  ViewModule,
} from '@mui/icons-material';
import { Student } from '@/types';
import axios from 'axios';

export const Students: React.FC = () => {
  const [students, setStudents] = useState<Student[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [viewMode, setViewMode] = useState<'table' | 'card'>('table');
  const [searchTerm, setSearchTerm] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedStudent, setSelectedStudent] = useState<Student | null>(null);

  // Add/Edit Student State
  const [openAddDialog, setOpenAddDialog] = useState(false);
  const [isEditing, setIsEditing] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);

  // Delete State
  const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
  const [studentToDelete, setStudentToDelete] = useState<Student | null>(null);

  const [formData, setFormData] = useState({
    studentCode: '',
    fullName: '',
    email: '',
    phone: '',
    dateOfBirth: '',
    address: '',
    campusId: '',
    departmentId: '',
    courseId: '',
    batch: '',
    admissionDate: '',
    guardianName: '',
    guardianPhone: '',
    guardianEmail: ''
  });

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const formatDateForInput = (dateString: string) => {
    if (!dateString) return '';
    return dateString.split('T')[0];
  };

  const resetForm = () => {
    setFormData({
      studentCode: '',
      fullName: '',
      email: '',
      phone: '',
      dateOfBirth: '',
      address: '',
      campusId: '',
      departmentId: '',
      courseId: '',
      batch: '',
      admissionDate: '',
      guardianName: '',
      guardianPhone: '',
      guardianEmail: ''
    });
    setIsEditing(false);
    setEditingId(null);
  };

  const handleOpenAdd = () => {
    resetForm();
    setOpenAddDialog(true);
  };

  const handleEditClick = (student: Student) => {
    setIsEditing(true);
    // Student.id is string from frontend mapping, but backend needs int ID for URL
    setEditingId(parseInt(student.id));

    setFormData({
      studentCode: student.studentId, // mapped from studentCode
      fullName: student.name,
      email: student.email,
      phone: student.phone,
      dateOfBirth: formatDateForInput(student.dateOfBirth),
      address: student.address,
      campusId: student.campusId,
      departmentId: student.departmentId,
      courseId: student.courseId,
      batch: student.batch,
      admissionDate: formatDateForInput(student.admissionDate),
      guardianName: student.guardianName || '',
      guardianPhone: student.guardianPhone || '',
      guardianEmail: student.guardianEmail || ''
    });
    setOpenAddDialog(true);
  };

  const handleDeleteClick = (student: Student) => {
    setStudentToDelete(student);
    setOpenDeleteDialog(true);
  };

  const handleDeleteConfirm = async () => {
    if (!studentToDelete) return;
    try {
      setLoading(true);
      await axios.delete(`http://localhost:5011/api/student/${studentToDelete.id}`);
      setOpenDeleteDialog(false);
      setStudentToDelete(null);
      fetchStudents();
    } catch (err) {
      console.error('Error deleting student:', err);
      // Extract specific error message from backend if available
      const errorMessage = (err as any).response?.data?.message || (err as any).message || 'Failed to delete student.';
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const handleFormSubmit = async () => {
    // Basic validation
    if (!formData.studentCode || !formData.fullName || !formData.email || !formData.phone ||
      !formData.dateOfBirth || !formData.campusId || !formData.departmentId || !formData.courseId ||
      !formData.batch || !formData.admissionDate) {
      setError('Please fill in all required fields.');
      return;
    }

    try {
      setLoading(true);
      setError(null);
      const payload = {
        StudentCode: formData.studentCode,
        FullName: formData.fullName,
        Email: formData.email,
        Phone: formData.phone,
        DateOfBirth: formData.dateOfBirth,
        Address: formData.address,
        CampusId: parseInt(formData.campusId) || 0,
        DepartmentId: parseInt(formData.departmentId) || 0,
        CourseId: parseInt(formData.courseId) || 0,
        Batch: formData.batch,
        AdmissionDate: formData.admissionDate,
        Status: 'Active', // Default
        GuardianName: formData.guardianName,
        GuardianPhone: formData.guardianPhone,
        GuardianEmail: formData.guardianEmail
      };

      console.log('Use this payload for debugging:', JSON.stringify(payload, null, 2));

      if (isEditing && editingId) {
        await axios.put(`http://localhost:5011/api/student/${editingId}`, payload);
      } else {
        await axios.post('http://localhost:5011/api/student', payload);
      }

      setOpenAddDialog(false);
      fetchStudents();
      resetForm();
    } catch (err: any) {
      console.error('Error saving student:', err);
      const errorMessage = err.response?.data?.message || err.message || 'Failed to save student. Please check your inputs.';
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchStudents();
  }, []);

  const fetchStudents = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await axios.get('http://localhost:5011/api/student');

      // Map backend data (StudentDto) to frontend interface (Student)
      const mappedStudents: Student[] = Array.isArray(response.data)
        ? response.data.map((item: any) => ({
          id: item.studentId?.toString() || '',
          studentId: item.studentCode || '',
          name: item.fullName || '',
          email: item.email || '',
          phone: item.phone || '',
          dateOfBirth: item.dateOfBirth || '',
          address: item.address || '',
          campusId: item.campusId?.toString() || '',
          departmentId: item.departmentId?.toString() || '',
          courseId: item.courseId?.toString() || '',
          batch: item.batch || '',
          admissionDate: item.admissionDate || '',
          status: (item.status?.toLowerCase() as any) || 'active',
          guardianName: item.guardianName,
          guardianPhone: item.guardianPhone,
          guardianEmail: item.guardianEmail,
        }))
        : [];

      setStudents(mappedStudents);
    } catch (err) {
      setError('Failed to fetch students. Please check if the API is running.');
      console.error('Error fetching students:', err);
    } finally {
      setLoading(false);
    }
  };

  const filteredStudents = students.filter(
    (student) =>
      student.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      student.studentId.toLowerCase().includes(searchTerm.toLowerCase()) ||
      student.email.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const handleView = (student: Student) => {
    setSelectedStudent(student);
    setOpenDialog(true);
  };

  return (
    <Box>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h4">Student Management</Typography>
        <Box sx={{ display: 'flex', gap: 2, alignItems: 'center' }}>
          <ButtonGroup variant="outlined" size="small">
            <Button
              variant={viewMode === 'table' ? 'contained' : 'outlined'}
              onClick={() => setViewMode('table')}
              startIcon={<ViewList />}
            >
              Table View
            </Button>
            <Button
              variant={viewMode === 'card' ? 'contained' : 'outlined'}
              onClick={() => setViewMode('card')}
              startIcon={<ViewModule />}
            >
              Card View
            </Button>
          </ButtonGroup>
          <Button variant="contained" startIcon={<Add />} onClick={handleOpenAdd}>
            Add Student
          </Button>
        </Box>
      </Box>

      <Paper sx={{ p: 2, mb: 3 }}>
        <TextField
          fullWidth
          placeholder="Search by name, student ID, or email..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <Search />
              </InputAdornment>
            ),
          }}
        />
      </Paper>

      {loading && (
        <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '400px' }}>
          <CircularProgress />
        </Box>
      )}

      {error && (
        <Alert severity="error" sx={{ mb: 3 }} onClose={() => setError(null)}>
          {error}
        </Alert>
      )}

      {!loading && !error && (
        <>
          {viewMode === 'table' ? (
            <TableContainer component={Paper}>
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell>Student ID</TableCell>
                    <TableCell>Name</TableCell>
                    <TableCell>Email</TableCell>
                    <TableCell>Phone</TableCell>
                    <TableCell>Course</TableCell>
                    <TableCell>Batch</TableCell>
                    <TableCell>Status</TableCell>
                    <TableCell>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredStudents.map((student) => (
                    <TableRow key={student.id}>
                      <TableCell>{student.studentId}</TableCell>
                      <TableCell>{student.name}</TableCell>
                      <TableCell>{student.email}</TableCell>
                      <TableCell>{student.phone}</TableCell>
                      <TableCell>Course {student.courseId}</TableCell>
                      <TableCell>{student.batch}</TableCell>
                      <TableCell>
                        <Chip
                          label={student.status}
                          color={student.status === 'active' ? 'success' : 'default'}
                          size="small"
                        />
                      </TableCell>
                      <TableCell>
                        <IconButton size="small" onClick={() => handleView(student)}>
                          <Visibility />
                        </IconButton>
                        <IconButton size="small" onClick={() => handleEditClick(student)}>
                          <Edit />
                        </IconButton>
                        <IconButton size="small" onClick={() => handleDeleteClick(student)} color="error">
                          <Delete />
                        </IconButton>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          ) : (
            <Grid container spacing={3}>
              {filteredStudents.map((student) => (
                <Grid item xs={12} sm={6} md={4} lg={3} key={student.id}>
                  <Card sx={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
                    <CardContent sx={{ flexGrow: 1 }}>
                      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start', mb: 2 }}>
                        <Box>
                          <Typography variant="h6" gutterBottom>
                            {student.name}
                          </Typography>
                          <Typography variant="body2" color="textSecondary">
                            {student.studentId}
                          </Typography>
                        </Box>
                        <Chip
                          label={student.status}
                          color={student.status === 'active' ? 'success' : 'default'}
                          size="small"
                        />
                      </Box>
                      <Box sx={{ mt: 2 }}>
                        <Typography variant="body2" color="textSecondary" gutterBottom>
                          <strong>Email:</strong> {student.email}
                        </Typography>
                        <Typography variant="body2" color="textSecondary" gutterBottom>
                          <strong>Phone:</strong> {student.phone}
                        </Typography>
                        <Typography variant="body2" color="textSecondary" gutterBottom>
                          <strong>Course:</strong> Course {student.courseId}
                        </Typography>
                        <Typography variant="body2" color="textSecondary" gutterBottom>
                          <strong>Batch:</strong> {student.batch}
                        </Typography>
                        <Typography variant="body2" color="textSecondary">
                          <strong>Admission:</strong> {new Date(student.admissionDate).toLocaleDateString()}
                        </Typography>
                      </Box>
                    </CardContent>
                    <Box sx={{ p: 2, pt: 0, display: 'flex', gap: 1, justifyContent: 'flex-end' }}>
                      <IconButton size="small" onClick={() => handleView(student)} color="primary">
                        <Visibility />
                      </IconButton>
                      <IconButton size="small" color="primary" onClick={() => handleEditClick(student)}>
                        <Edit />
                      </IconButton>
                      <IconButton size="small" color="error" onClick={() => handleDeleteClick(student)}>
                        <Delete />
                      </IconButton>
                    </Box>
                  </Card>
                </Grid>
              ))}
            </Grid>
          )}
        </>
      )}

      {!loading && !error && filteredStudents.length === 0 && (
        <Paper sx={{ p: 4, textAlign: 'center' }}>
          <Typography variant="h6" color="textSecondary">
            No students found
          </Typography>
        </Paper>
      )}

      <Dialog open={openDialog} onClose={() => setOpenDialog(false)} maxWidth="md" fullWidth>
        <DialogTitle>Student Details</DialogTitle>
        <DialogContent>
          {selectedStudent && (
            <Grid container spacing={2} sx={{ mt: 1 }}>
              <Grid item xs={12} sm={6}>
                <Typography variant="body2" color="textSecondary">Student ID</Typography>
                <Typography variant="body1">{selectedStudent.studentId}</Typography>
              </Grid>
              <Grid item xs={12} sm={6}>
                <Typography variant="body2" color="textSecondary">Name</Typography>
                <Typography variant="body1">{selectedStudent.name}</Typography>
              </Grid>
              <Grid item xs={12} sm={6}>
                <Typography variant="body2" color="textSecondary">Email</Typography>
                <Typography variant="body1">{selectedStudent.email}</Typography>
              </Grid>
              <Grid item xs={12} sm={6}>
                <Typography variant="body2" color="textSecondary">Phone</Typography>
                <Typography variant="body1">{selectedStudent.phone}</Typography>
              </Grid>
              <Grid item xs={12} sm={6}>
                <Typography variant="body2" color="textSecondary">Date of Birth</Typography>
                <Typography variant="body1">
                  {new Date(selectedStudent.dateOfBirth).toLocaleDateString()}
                </Typography>
              </Grid>
              <Grid item xs={12} sm={6}>
                <Typography variant="body2" color="textSecondary">Admission Date</Typography>
                <Typography variant="body1">
                  {new Date(selectedStudent.admissionDate).toLocaleDateString()}
                </Typography>
              </Grid>
              {selectedStudent.guardianName && (
                <>
                  <Grid item xs={12} sm={6}>
                    <Typography variant="body2" color="textSecondary">Guardian Name</Typography>
                    <Typography variant="body1">{selectedStudent.guardianName}</Typography>
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Typography variant="body2" color="textSecondary">Guardian Phone</Typography>
                    <Typography variant="body1">{selectedStudent.guardianPhone}</Typography>
                  </Grid>
                </>
              )}
            </Grid>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenDialog(false)}>Close</Button>
        </DialogActions>
      </Dialog>

      {/* Add/Edit Student Dialog */}
      <Dialog open={openAddDialog} onClose={() => setOpenAddDialog(false)} maxWidth="md" fullWidth>
        <DialogTitle>{isEditing ? 'Edit Student' : 'Add New Student'}</DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12} sm={6}>
              <TextField fullWidth label="Student Code" name="studentCode" value={formData.studentCode} onChange={handleInputChange} required />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField fullWidth label="Full Name" name="fullName" value={formData.fullName} onChange={handleInputChange} required />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField fullWidth label="Email" name="email" type="email" value={formData.email} onChange={handleInputChange} required />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField fullWidth label="Phone" name="phone" value={formData.phone} onChange={handleInputChange} required />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField fullWidth label="Date of Birth" name="dateOfBirth" type="date" InputLabelProps={{ shrink: true }} value={formData.dateOfBirth} onChange={handleInputChange} required />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField fullWidth label="Admission Date" name="admissionDate" type="date" InputLabelProps={{ shrink: true }} value={formData.admissionDate} onChange={handleInputChange} required />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField fullWidth label="Address" name="address" value={formData.address} onChange={handleInputChange} multiline rows={2} />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField fullWidth label="Batch" name="batch" value={formData.batch} onChange={handleInputChange} required />
            </Grid>
            {/* Numeric Inputs for Foreign Keys */}
            <Grid item xs={12} sm={4}>
              <TextField fullWidth label="Campus ID" name="campusId" type="number" value={formData.campusId} onChange={handleInputChange} required helperText="Enter numeric ID" />
            </Grid>
            <Grid item xs={12} sm={4}>
              <TextField fullWidth label="Department ID" name="departmentId" type="number" value={formData.departmentId} onChange={handleInputChange} required helperText="Enter numeric ID" />
            </Grid>
            <Grid item xs={12} sm={4}>
              <TextField fullWidth label="Course ID" name="courseId" type="number" value={formData.courseId} onChange={handleInputChange} required helperText="Enter numeric ID" />
            </Grid>

            <Grid item xs={12}><Typography variant="subtitle1" sx={{ mt: 2 }}>Guardian Info</Typography></Grid>
            <Grid item xs={12} sm={4}>
              <TextField fullWidth label="Guardian Name" name="guardianName" value={formData.guardianName} onChange={handleInputChange} />
            </Grid>
            <Grid item xs={12} sm={4}>
              <TextField fullWidth label="Guardian Phone" name="guardianPhone" value={formData.guardianPhone} onChange={handleInputChange} />
            </Grid>
            <Grid item xs={12} sm={4}>
              <TextField fullWidth label="Guardian Email" name="guardianEmail" value={formData.guardianEmail} onChange={handleInputChange} />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenAddDialog(false)}>Cancel</Button>
          <Button onClick={handleFormSubmit} variant="contained" color="primary">
            {isEditing ? 'Update Student' : 'Save Student'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Delete Confirmation Dialog */}
      <Dialog open={openDeleteDialog} onClose={() => setOpenDeleteDialog(false)}>
        <DialogTitle>Confirm Delete</DialogTitle>
        <DialogContent>
          <Typography>
            Are you sure you want to delete student <strong>{studentToDelete?.name}</strong>?
            This action cannot be undone.
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenDeleteDialog(false)}>Cancel</Button>
          <Button onClick={handleDeleteConfirm} color="error" variant="contained">
            Delete
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};
