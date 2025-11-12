import React from 'react';
import Layout from '../components/layout/Layout';
import { Trophy, Star, Award, TrendingUp, Users, Target } from 'lucide-react';

const GamificationGrading: React.FC = () => {
  const topStudents = [
    { id: 1, name: 'Alice Johnson', points: 2450, level: 'Expert', badges: 12, rank: 1, avatar: 'AJ' },
    { id: 2, name: 'Bob Smith', points: 2380, level: 'Expert', badges: 11, rank: 2, avatar: 'BS' },
    { id: 3, name: 'Carol Davis', points: 2290, level: 'Advanced', badges: 10, rank: 3, avatar: 'CD' },
    { id: 4, name: 'David Wilson', points: 2150, level: 'Advanced', badges: 9, rank: 4, avatar: 'DW' },
    { id: 5, name: 'Emma Brown', points: 2080, level: 'Advanced', badges: 8, rank: 5, avatar: 'EB' }
  ];

  const achievements = [
    { id: 1, title: 'Math Master', description: 'Complete 50 math problems', icon: '🧮', earned: 156 },
    { id: 2, title: 'Science Explorer', description: 'Finish 10 science experiments', icon: '🔬', earned: 89 },
    { id: 3, title: 'Reading Champion', description: 'Read 25 books', icon: '📚', earned: 234 },
    { id: 4, title: 'Perfect Attendance', description: 'Attend all classes for a month', icon: '📅', earned: 67 }
  ];

  const progressData = [
    { subject: 'Mathematics', progress: 85, color: 'bg-blue-500' },
    { subject: 'Science', progress: 92, color: 'bg-green-500' },
    { subject: 'English', progress: 78, color: 'bg-purple-500' },
    { subject: 'History', progress: 88, color: 'bg-orange-500' }
  ];

  return (
    <Layout>
      <div className="space-y-6">
        {/* Page Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Gamification & Grading</h1>
            <p className="text-gray-600 mt-1">Track student progress, rankings, and achievements</p>
          </div>
          <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2">
            <Award className="w-4 h-4" />
            <span>Create Achievement</span>
          </button>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Total Points Awarded</p>
                <p className="text-2xl font-bold text-gray-900 mt-2">45,678</p>
              </div>
              <div className="w-12 h-12 bg-yellow-500 rounded-lg flex items-center justify-center">
                <Star className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Active Students</p>
                <p className="text-2xl font-bold text-gray-900 mt-2">1,248</p>
              </div>
              <div className="w-12 h-12 bg-blue-500 rounded-lg flex items-center justify-center">
                <Users className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Achievements Unlocked</p>
                <p className="text-2xl font-bold text-gray-900 mt-2">546</p>
              </div>
              <div className="w-12 h-12 bg-purple-500 rounded-lg flex items-center justify-center">
                <Award className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-lg p-6 shadow-sm border border-gray-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Avg Progress</p>
                <p className="text-2xl font-bold text-gray-900 mt-2">86%</p>
              </div>
              <div className="w-12 h-12 bg-green-500 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Student Rankings */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200">
            <div className="px-6 py-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900 flex items-center">
                <Trophy className="w-5 h-5 mr-2 text-yellow-500" />
                Top Students
              </h3>
            </div>
            <div className="p-6">
              <div className="space-y-4">
                {topStudents.map((student) => (
                  <div key={student.id} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                    <div className="flex items-center space-x-4">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center text-white font-semibold ${
                        student.rank === 1 ? 'bg-yellow-500' :
                        student.rank === 2 ? 'bg-gray-400' :
                        student.rank === 3 ? 'bg-orange-600' : 'bg-blue-500'
                      }`}>
                        {student.rank}
                      </div>
                      <div className="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center text-white font-semibold">
                        {student.avatar}
                      </div>
                      <div>
                        <div className="font-medium text-gray-900">{student.name}</div>
                        <div className="text-sm text-gray-500">{student.level}</div>
                      </div>
                    </div>
                    <div className="text-right">
                      <div className="font-semibold text-gray-900">{student.points} pts</div>
                      <div className="text-sm text-gray-500">{student.badges} badges</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Subject Progress */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200">
            <div className="px-6 py-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900 flex items-center">
                <Target className="w-5 h-5 mr-2 text-blue-500" />
                Subject Progress
              </h3>
            </div>
            <div className="p-6">
              <div className="space-y-6">
                {progressData.map((item, index) => (
                  <div key={index}>
                    <div className="flex justify-between items-center mb-2">
                      <span className="text-sm font-medium text-gray-700">{item.subject}</span>
                      <span className="text-sm text-gray-500">{item.progress}%</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className={`h-2 rounded-full ${item.color}`}
                        style={{ width: `${item.progress}%` }}
                      ></div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>

        {/* Achievements */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-semibold text-gray-900">Available Achievements</h3>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 p-6">
            {achievements.map((achievement) => (
              <div key={achievement.id} className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                <div className="text-center">
                  <div className="text-4xl mb-3">{achievement.icon}</div>
                  <h4 className="text-lg font-semibold text-gray-900 mb-2">{achievement.title}</h4>
                  <p className="text-sm text-gray-600 mb-4">{achievement.description}</p>
                  <div className="bg-blue-50 rounded-lg p-2">
                    <span className="text-sm font-medium text-blue-700">{achievement.earned} students earned</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default GamificationGrading;
