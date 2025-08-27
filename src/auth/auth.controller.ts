import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { AuthService } from '@/auth/auth.service';
import { RegisterDto } from '@/auth/dto/register.dto';
import { LoginDto } from '@/auth/dto/login.dto';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { CurrentUser } from '@/common/decorators/user.decorator';

@Controller('auth')
export class AuthController {
    constructor(private auth: AuthService) {}

    @Post('register')
    register(@Body() dto: RegisterDto) {
        return this.auth.register(dto.email, dto.password);
    }

    @Post('login')
    login(@Body() dto: LoginDto) {
        return this.auth.login(dto.email, dto.password);
    }

    @UseGuards(JwtAuthGuard)
    @Get('me')
    me(@CurrentUser() user: any) {
        return user;
    }
}
