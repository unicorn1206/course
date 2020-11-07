package com.course.system.controller.admin;

import com.course.server.domain.User;
import com.course.server.dto.*;
import com.course.server.service.UserService;
import com.course.server.util.ValidatorUtil;
import org.springframework.http.HttpRequest;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RestController
@RequestMapping("/admin/user")//访问地址与包名对应
public class UserController {

    public static final String BUSINESS_NAME = "用户";

    @Resource
    private UserService userService;

    /**
     * 列表查询
     */
    @PostMapping("/list")
    public ResponseDto list(@RequestBody PageDto pageDto){
        ResponseDto responseDto = new ResponseDto();
        userService.list(pageDto);
        responseDto.setContent(pageDto);
        return responseDto;
    }

    /**
     * 保存，id有值时更新，无值时新增
     */
    @PostMapping("/save")
    public ResponseDto save(@RequestBody UserDto userDto){
        ResponseDto responseDto = new ResponseDto();

        userDto.setPassword(DigestUtils.md5DigestAsHex(userDto.getPassword().getBytes()));

        // 保存校验
        ValidatorUtil.require(userDto.getLoginName(), "登录名");
        ValidatorUtil.length(userDto.getLoginName(), "登录名", 1, 50);
        ValidatorUtil.length(userDto.getName(), "昵称", 1, 50);
        ValidatorUtil.require(userDto.getPassword(), "密码");

        userService.save(userDto);
        responseDto.setContent(userDto);
        return responseDto;
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public ResponseDto delete(@PathVariable String id){
        ResponseDto responseDto = new ResponseDto();
        userService.delete(id);
        return responseDto;
    }

    /**
     * 重置密码
     */
    @PostMapping("/save-password")
    public ResponseDto savePassword(@RequestBody UserDto userDto){
        ResponseDto responseDto = new ResponseDto();
        userDto.setPassword(DigestUtils.md5DigestAsHex(userDto.getPassword().getBytes()));
        userService.savePassword(userDto);
        responseDto.setContent(userDto);
        return responseDto;
    }

    /**
     * 登录
     */
    @PostMapping("/login")
    public ResponseDto login(@RequestBody UserDto userDto, HttpServletRequest request){
        ResponseDto responseDto = new ResponseDto();
        userDto.setPassword(DigestUtils.md5DigestAsHex(userDto.getPassword().getBytes()));
        LoginUserDto loginUserDto = userService.login(userDto);
        request.getSession().setAttribute(Constants.LOGIN_USER,loginUserDto);
        responseDto.setContent(loginUserDto);
        return responseDto;
    }

    /**
     * 退出登录
     */
    @GetMapping("/logout")
    public ResponseDto logout(HttpServletRequest request){
        ResponseDto responseDto = new ResponseDto();
        //request.getSession().setAttribute(Constants.LOGIN_USER,null);等同于下一行代码
        request.getSession().removeAttribute(Constants.LOGIN_USER);
        return responseDto;
    }
}
