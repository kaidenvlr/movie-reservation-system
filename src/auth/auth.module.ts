import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { UsersModule } from '@/users/users.module';
import { AuthService } from '@/auth/auth.service';
import { AuthController } from '@/auth/auth.controller';
import { JwtStrategy } from '@/auth/strategies/jwt.strategy';

@Module({
    imports: [
        UsersModule,
        JwtModule.register({
            // секрет и срок жизни можно не указывать — задаём при sign
            global: true,
        }),
    ],
    controllers: [AuthController],
    providers: [AuthService, JwtStrategy],
})
export class AuthModule {}
