package com.niuma.admin.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.niuma.admin.entity.PlayerLoginLog;
import com.niuma.admin.mapper.PlayerLoginLogMapper;
import com.niuma.admin.service.IPlayerLoginLogService;
import org.springframework.stereotype.Service;

@Service
public class PlayerLoginLogServiceImpl extends ServiceImpl<PlayerLoginLogMapper, PlayerLoginLog> implements IPlayerLoginLogService {
}
