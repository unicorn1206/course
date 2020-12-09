package com.course.business.controller.admin;

import com.course.server.domain.Course;
import com.course.server.domain.CourseCategory;
import com.course.server.domain.CourseCategoryExample;
import com.course.server.domain.CourseContent;
import com.course.server.dto.*;
import com.course.server.mapper.CourseCategoryMapper;
import com.course.server.service.CourseService;
import com.course.server.util.CopyUtil;
import com.course.server.util.ValidatorUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/admin/course")//访问地址与包名对应
public class CourseController {

    private static final Logger LOG = LoggerFactory.getLogger(CourseController.class);

    public static final String BUSINESS_NAME = "课程";

    @Resource
    private CourseService courseService;



    /**
     * 列表查询
     */
    @PostMapping("/list")
    public ResponseDto list(@RequestBody CoursePageDto pageDto){
        ResponseDto responseDto = new ResponseDto();
        courseService.list(pageDto);
        responseDto.setContent(pageDto);
        return responseDto;
    }

    /**
     * 保存，id有值时更新，无值时新增
     */
    @PostMapping("/save")
    public ResponseDto save(@RequestBody CourseDto courseDto){
        ResponseDto responseDto = new ResponseDto();

        // 保存校验
        ValidatorUtil.require(courseDto.getName(), "名称");
        ValidatorUtil.length(courseDto.getName(), "名称", 1, 50);
        ValidatorUtil.length(courseDto.getSummary(), "概述", 1, 2000);
        ValidatorUtil.length(courseDto.getImage(), "封面", 1, 100);

        courseService.save(courseDto);
        responseDto.setContent(courseDto);
        return responseDto;
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public ResponseDto delete(@PathVariable String id){
        ResponseDto responseDto = new ResponseDto();
        courseService.delete(id);
        return responseDto;
    }

    /**
     * 查询课程下所有分类
     * @param courseId
     * @return
     */
    @PostMapping("/list-category/{courseId}")
    public ResponseDto listByCourse(@PathVariable(value = "courseId") String courseId){
        ResponseDto responseDto = new ResponseDto();
        List<CourseCategoryDto> dtoList = courseService.listByCourse(courseId);
        responseDto.setContent(dtoList);
        return responseDto;
    }

    @GetMapping("/find-content/{id}")
    public ResponseDto findContent(@PathVariable String id){
        ResponseDto responseDto = new ResponseDto();
        CourseContentDto courseContentDto = courseService.findContent(id);
        responseDto.setContent(courseContentDto);
        return responseDto;
    }

    @PostMapping("/save-content")
    public ResponseDto saveContent(@RequestBody CourseContentDto courseContentDto){
        ResponseDto responseDto = new ResponseDto();
        courseService.saveContent(courseContentDto);
        return responseDto;
    }

    @RequestMapping("/sort")
    public ResponseDto sort(@RequestBody SortDto sortDto){
        LOG.info("更新排序");
        ResponseDto responseDto = new ResponseDto();
        courseService.sort(sortDto);
        return responseDto;
    }
}
