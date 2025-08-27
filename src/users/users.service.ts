import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { User, UserRole } from '@prisma/client';

@Injectable()
export class UsersService {
    constructor(private readonly prisma: PrismaService) {}

    findByEmail(email: string) {
        return this.prisma.user.findUnique({
            where: {
                email,
            },
        });
    }

    async create(
        email: string,
        passwordHash: string,
        role: UserRole = 'USER',
    ): Promise<User> {
        return this.prisma.user.create({
            data: {
                email,
                passwordHash,
                role,
            },
        });
    }

    async findByIdPublic(id: string) {
        const { passwordHash, ...user } =
            await this.prisma.user.findUniqueOrThrow({
                where: {
                    id,
                },
            });
        return user;
    }
}
