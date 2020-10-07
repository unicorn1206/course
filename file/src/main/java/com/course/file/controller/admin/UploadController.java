package com.course.file.controller.admin;

import com.course.server.domain.Test;
import com.course.server.dto.FileDto;
import com.course.server.dto.ResponseDto;
import com.course.server.enums.FileUseEnum;
import com.course.server.service.FileService;
import com.course.server.service.TestService;
import com.course.server.util.Base64ToMultipartFile;
import com.course.server.util.UuidUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.*;
import java.util.List;

@RestController
@RequestMapping("/admin")
public class UploadController {

    private static final Logger LOG = LoggerFactory.getLogger(UploadController.class);

    public static final String BUSINESS_NAME = "文件上传";

    @Value("${file.path}")
    private String FILE_PATH;

    @Value("${file.domain}")
    private String FILE_DOMAIN;

    @Resource
    private TestService testService;

    @Resource
    private FileService fileService;

    @RequestMapping("/upload")
    public ResponseDto upload(@RequestBody FileDto fileDto) throws IOException {
        LOG.info("上传文件开始");
        String use = fileDto.getUse();
        String key = fileDto.getKey();
        String suffix = fileDto.getSuffix();
        String shardBase64 = fileDto.getShard();
        MultipartFile shard = Base64ToMultipartFile.base64ToMultipart(shardBase64);

        //保存文件到本地
        FileUseEnum useEnum = FileUseEnum.getByCode(use);//useEnum为一整个枚举类型：TEACHER("T", "讲师")

        //如果文件夹不存在则创建
        String dir = useEnum.name().toLowerCase() + "Pic";
        File fullDir = new File(FILE_PATH + dir);
        if(!fullDir.exists()){
            fullDir.mkdir();
        }
        String path = dir + File.separator + key + "." + suffix;
        String fullPath = FILE_PATH + path;
        File dest = new File(fullPath);
        shard.transferTo(dest);
        LOG.info(dest.getAbsolutePath());

        LOG.info("保存文件记录开始");
        fileDto.setPath(path);
        fileService.save(fileDto);

        ResponseDto responseDto = new ResponseDto();
        fileDto.setPath(FILE_DOMAIN + path);
        responseDto.setContent(fileDto);
        return responseDto;
    }

    @GetMapping("/merge")
    public ResponseDto merger() throws Exception {
        File newFile = new File(FILE_PATH + "course/test123.mp4");
        FileOutputStream outputStream = new FileOutputStream(newFile,true);//true:文件追加写入
        FileInputStream fileInputStream = null;//分片文件
        byte[] byt = new byte[10 * 1024 * 1024];
        int len;

        try{
            //读取第一个分片
            fileInputStream = new FileInputStream(new File(FILE_PATH + "course/test123.mp4"));
            while((len=fileInputStream.read(byt)) != -1){
                outputStream.write(byt,0,len);
            }

            //读取第二个分片
            fileInputStream = new FileInputStream(new File(FILE_PATH + "course/test123.mp4"));
            while((len=fileInputStream.read(byt)) != -1){
                outputStream.write(byt,0,len);
            }
        }catch (Exception e){
            LOG.error("文件合并异常",e);
        }finally {
            try {
                if(fileInputStream != null){
                    fileInputStream.close();
                }
                outputStream.close();
                LOG.info("IO流关闭");
            }catch (Exception e){
                LOG.error("IO流关闭",e);
            }
        }
        ResponseDto responseDto = new ResponseDto();
        return responseDto;
    }
}
