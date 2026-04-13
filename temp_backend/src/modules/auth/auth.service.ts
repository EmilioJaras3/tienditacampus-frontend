import { Injectable, UnauthorizedException } from '@nestjs/common';
import { UsersService } from '../users/users.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { GoogleLoginDto } from './dto/google-login.dto';
import { LoginUseCase } from './use-cases/login.use-case';
import { RegisterUseCase } from './use-cases/register.use-case';
import { GoogleLoginUseCase } from './use-cases/google-login.use-case';

@Injectable()
export class AuthService {
    constructor(
        private readonly usersService: UsersService,
        private readonly loginUseCase: LoginUseCase,
        private readonly registerUseCase: RegisterUseCase,
        private readonly googleLoginUseCase: GoogleLoginUseCase,
    ) { }

    async register(dto: RegisterDto) {
        return this.registerUseCase.execute(dto);
    }

    async login(dto: LoginDto) {
        return this.loginUseCase.execute(dto);
    }

    async loginWithGoogle(dto: GoogleLoginDto) {
        return this.googleLoginUseCase.execute(dto);
    }

    async getProfile(userId: string) {
        const user = await this.usersService.findById(userId);
        if (!user) {
            throw new UnauthorizedException('Usuario no encontrado');
        }
        return user;
    }
}
