package com.course.server.service;

import com.course.server.domain.Chapter;
import com.course.server.domain.ChapterExample;
import com.course.server.dto.ChapterDto;
import com.course.server.dto.PageDto;
import com.course.server.mapper.ChapterMapper;
import com.course.server.util.CopyUtil;
import com.course.server.util.UuidUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
public class ChapterService {

    @Resource
    private ChapterMapper chapterMapper;

    public PageDto  list(PageDto pageDto){
        PageHelper.startPage(pageDto.getPage(),pageDto.getSize());//第几页、每页有几条
        ChapterExample chapterExample = new ChapterExample();
        List<Chapter> chapterList = chapterMapper.selectByExample(chapterExample);
        PageInfo<Chapter> pageInfo = new PageInfo<>(chapterList);
        List<ChapterDto> chapterDtoList = CopyUtil.copyList(chapterList,ChapterDto.class);
        pageDto.setTotal(pageInfo.getTotal());
        pageDto.setList(chapterDtoList);
        return pageDto;
    }

    public void save(ChapterDto chapterDto) {
        Chapter chapter = CopyUtil.copy(chapterDto,Chapter.class);
       if(StringUtils.isEmpty(chapterDto.getId())){
           this.insert(chapter);
       }else{
           this.update(chapter);
       }
    }

    private void insert(Chapter chapter) {
        chapter.setId(UuidUtil.getShortUuid());
        chapterMapper.insert(chapter);
    }

    private void update(Chapter chapter) {
        chapterMapper.updateByPrimaryKey(chapter);
    }
}
