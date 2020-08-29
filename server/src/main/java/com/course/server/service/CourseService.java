package com.course.server.service;

import com.course.server.domain.*;
import com.course.server.dto.*;
import com.course.server.mapper.CourseCategoryMapper;
import com.course.server.mapper.CourseContentMapper;
import com.course.server.mapper.CourseMapper;
import com.course.server.mapper.my.MyCourseMapper;
import com.course.server.util.CopyUtil;
import com.course.server.util.UuidUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import javax.annotation.Resource;
import java.util.List;
import java.util.Date;

@Service
public class CourseService {

    @Resource
    private CourseMapper courseMapper;

    @Resource
    private MyCourseMapper myCourseMapper;

    @Resource
    private CourseCategoryService courseCategoryService;

    @Resource
    private CourseCategoryMapper courseCategoryMapper;

    @Resource
    private CourseContentMapper courseContentMapper;

    /**
     * 列表查询
     */
    public void list(PageDto pageDto) {
        PageHelper.startPage(pageDto.getPage(), pageDto.getSize());
        CourseExample courseExample = new CourseExample();
        courseExample.setOrderByClause("sort asc");
        List<Course> courseList = courseMapper.selectByExample(courseExample);
        PageInfo<Course> pageInfo = new PageInfo<>(courseList);
        pageDto.setTotal(pageInfo.getTotal());
        List<CourseDto> courseDtoList = CopyUtil.copyList(courseList, CourseDto.class);
        pageDto.setList(courseDtoList);
    }

    /**
     * 保存，id有值时更新，无值时新增
     */
    @Transactional
    public void save(CourseDto courseDto) {
        Course course = CopyUtil.copy(courseDto, Course.class);
        if (StringUtils.isEmpty(courseDto.getId())) {
            this.insert(course);
        } else {
            this.update(course);
        }
        //批量保存分类
        courseCategoryService.saveBatch(course.getId(),courseDto.getCategorys());
    }

    /**
     * 新增
     */
    private void insert(Course course) {
        Date now = new Date();
        course.setCreateAt(now);
        course.setUpdateAt(now);
        course.setId(UuidUtil.getShortUuid());
        courseMapper.insert(course);
    }

    /**
     * 更新
     */
    private void update(Course course) {
        course.setUpdateAt(new Date());
        courseMapper.updateByPrimaryKey(course);
    }

    /**
     * 删除
     */
    public void delete(String id) {
        courseMapper.deleteByPrimaryKey(id);
    }

    /**
     * 更新课程时长
     * @param courseId
     */
    public void updateTime(String courseId){
        myCourseMapper.updateTime(courseId);
    }

    /**
     * 查询课程下所有分类
     * @param courseId
     * @return
     */
    public List<CourseCategoryDto> listByCourse(String courseId){
        CourseCategoryExample courseCategoryExample = new CourseCategoryExample();
        courseCategoryExample.createCriteria().andCourseIdEqualTo(courseId);
        List<CourseCategory> courseCategories = courseCategoryMapper.selectByExample(courseCategoryExample);
        return CopyUtil.copyList(courseCategories,CourseCategoryDto.class);
    }

    /**
     * 查找课程内容
     * @param id
     * @return
     */
    public CourseContentDto findContent(String id){
        CourseContent courseContent = courseContentMapper.selectByPrimaryKey(id);
        if(courseContent == null){
            return null;
        }
        return CopyUtil.copy(courseContent,CourseContentDto.class);
    }

    /**
     * 保存课程内容，包含新增和修改
     * @param courseContentDto
     * @return
     */
    public int saveContent(CourseContentDto courseContentDto){
        CourseContent courseContent = CopyUtil.copy(courseContentDto,CourseContent.class);
        int i = courseContentMapper.updateByPrimaryKeyWithBLOBs(courseContent);
        if(i == 0){
            courseContentMapper.insert(courseContent);
        }
        return i;
    }

    /**
     * 排序
     * @param sortDto
     */
    public void sort(SortDto sortDto) {
        // 修改当前记录的排序值
        myCourseMapper.updateSort(sortDto);

        // 如果排序值变大
        if (sortDto.getNewSort() > sortDto.getOldSort()) {
            myCourseMapper.moveSortsForward(sortDto);
        }

        // 如果排序值变小
        if (sortDto.getNewSort() < sortDto.getOldSort()) {
            myCourseMapper.moveSortsBackward(sortDto);
        }
    }

}
