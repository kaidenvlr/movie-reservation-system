import {
    BadRequestException,
    Injectable,
    UnauthorizedException,
} from '@nestjs/common';
import { UsersService } from '@/users/users.service';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { User } from '@prisma/client';

@Injectable()
export class AuthService {
    constructor(
        private users: UsersService,
        private jwt: JwtService,
    ) {}

    async register(email: string, password: string) {
        const exists = await this.users.findByEmail(email);
        if (exists) throw new BadRequestException('Email already in use');

        const hash = await bcrypt.hash(password, 10);
        const user = await this.users.create(email, hash);
        const accessToken = this.sign(user);

        const { passwordHash, ...publicUser } = user;
        return { user: publicUser, accessToken };
    }

    async login(email: string, password: string) {
        const user = await this.users.findByEmail(email);
        if (!user) throw new UnauthorizedException('Invalid credentials');

        const ok = await bcrypt.compare(password, user.passwordHash);
        if (!ok) throw new UnauthorizedException('Invalid credentials');

        const accessToken = this.sign(user);
        const { passwordHash, ...publicUser } = user;
        return { user: publicUser, accessToken };
    }

    private sign(user: User) {
        const payload = { sub: user.id, email: user.email, role: user.role };
        return this.jwt.sign(payload, {
            secret: process.env.JWT_SECRET,
            expiresIn: process.env.JWT_EXPIRES || '15m',
        });
    }
}
