'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { toast } from 'sonner';
import { authService } from '../../../services/auth.service';
import { Input } from '../../../components/ui/input';
import { Label } from '../../../components/ui/label';
import {
    Loader2,
    UserPlus,
    AtSign,
    Lock,
    User,
    GraduationCap,
    MapPin,
    CheckCircle2,
    Globe
} from 'lucide-react';
import { useGoogleLogin } from '@react-oauth/google';

const registerSchema = z.object({
    firstName: z.string().min(2, { message: 'Nombre muy corto' }),
    lastName: z.string().min(2, { message: 'Apellido muy corto' }),
    email: z.string().email({ message: 'Email inválido' }),
    password: z.string().min(6, { message: 'Mínimo 6 caracteres' }),
    campusLocation: z.string().min(3, { message: 'Requerido' }),
    major: z.string().min(3, { message: 'Requerido' }),
    role: z.enum(['buyer', 'seller']),
});

type RegisterFormData = z.infer<typeof registerSchema>;

export default function RegisterPage() {
    const router = useRouter();
    const [isLoading, setIsLoading] = useState(false);
    const [isGoogleLoading, setIsGoogleLoading] = useState(false);
    const [selectedRole, setSelectedRole] = useState<'buyer' | 'seller'>('buyer');

    const googleLogin = useGoogleLogin({
        onSuccess: async (tokenResponse) => {
            setIsGoogleLoading(true);
            try {
                const response = await authService.loginWithGoogle(tokenResponse.access_token);
                toast.success('¡Registro exitoso con Google!');
                if (response.user.role === 'buyer') {
                    router.push('/dashboard');
                } else {
                    router.push('/dashboard');
                }
            } catch (error: any) {
                toast.error(error.message || 'Error al registrar con Google');
            } finally {
                setIsGoogleLoading(false);
            }
        },
        onError: () => {
            toast.error('Ocurrió un error con el proveedor de Google');
        },
        scope: 'email profile'
    });

    const {
        register,
        handleSubmit,
        setValue,
        formState: { errors },
    } = useForm<RegisterFormData>({
        resolver: zodResolver(registerSchema),
        defaultValues: {
            role: 'buyer'
        }
    });

    const onSubmit = async (data: RegisterFormData) => {
        setIsLoading(true);
        try {
            await authService.register(data);
            toast.success('¡Registro exitoso! Ahora inicia sesión.');
            router.push('/login');
        } catch (error: any) {
            toast.error(error.message || 'Error al registrarse');
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div className="w-full max-w-2xl mx-auto py-10">
            {/* Header */}
            <div className="mb-10 text-center lg:text-left">
                <div className="inline-flex h-16 w-16 items-center justify-center border border-foreground/10 bg-primary text-primary-foreground shadow-md mb-6 rotate-3">
                    <UserPlus size={32} />
                </div>
                <h1 className="text-5xl font-semibold tracking-tighter text-foreground leading-none mb-3 uppercase">
                    ÚNETE A LA <br /> <span className="text-primary italic">TRIBU</span>
                </h1>
                <p className="text-lg font-bold text-muted-foreground border-l-4 border-foreground/10 pl-4 mt-4 uppercase">
                    Crea tu cuenta y empieza a mover el campus.
                </p>
            </div>

            {/* Form Container */}
            <div className="border border-foreground/10 bg-card p-8 md:p-12 shadow-md relative">
                <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">

                    {/* Role Selector */}
                    <div className="space-y-3">
                        <Label className="text-sm font-semibold tracking-widest text-foreground uppercase">¿Cuál es tu misión?</Label>
                        <div className="grid grid-cols-2 gap-4">
                            <button
                                type="button"
                                onClick={() => { setSelectedRole('buyer'); setValue('role', 'buyer'); }}
                                className={`p-4 border-2 flex flex-col items-center gap-2 transition-all ${selectedRole === 'buyer'
                                    ? 'bg-primary text-primary-foreground border-primary shadow-md'
                                    : 'bg-background border-foreground/10 opacity-60 hover:opacity-100'
                                    }`}
                            >
                                <CheckCircle2 className={`w-6 h-6 ${selectedRole === 'buyer' ? 'text-primary-foreground' : 'text-muted'}`} />
                                <span className="font-semibold text-xs">Comprar</span>
                            </button>
                            <button
                                type="button"
                                onClick={() => { setSelectedRole('seller'); setValue('role', 'seller'); }}
                                className={`p-4 border-2 flex flex-col items-center gap-2 transition-all ${selectedRole === 'seller'
                                    ? 'bg-primary text-primary-foreground border-primary shadow-md'
                                    : 'bg-background border-foreground/10 opacity-60 hover:opacity-100'
                                    }`}
                            >
                                <CheckCircle2 className={`w-6 h-6 ${selectedRole === 'seller' ? 'text-primary-foreground' : 'text-muted'}`} />
                                <span className="font-semibold text-xs">Vender</span>
                            </button>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        {/* Nombres */}
                        <div className="space-y-2">
                            <Label className="text-xs font-semibold text-foreground flex items-center gap-2"><User size={14} /> Nombre</Label>
                            <Input
                                {...register('firstName')}
                                className="neo-input"
                                placeholder="Ej. Juan"
                            />
                            {errors.firstName && <p className="text-xs font-bold text-primary italic uppercase">{errors.firstName.message}</p>}
                        </div>
                        <div className="space-y-2">
                            <Label className="text-xs font-semibold text-foreground flex items-center gap-2"><User size={14} /> Apellido</Label>
                            <Input
                                {...register('lastName')}
                                className="neo-input"
                                placeholder="Ej. Pérez"
                            />
                            {errors.lastName && <p className="text-xs font-bold text-primary italic uppercase">{errors.lastName.message}</p>}
                        </div>

                        {/* Académico */}
                        <div className="space-y-2">
                            <Label className="text-xs font-semibold text-foreground flex items-center gap-2"><MapPin size={14} /> Campus / Sede</Label>
                            <Input
                                {...register('campusLocation')}
                                className="neo-input"
                                placeholder="Ej. Campus Norte"
                            />
                            {errors.campusLocation && <p className="text-xs font-bold text-primary italic uppercase">{errors.campusLocation.message}</p>}
                        </div>
                        <div className="space-y-2">
                            <Label className="text-xs font-semibold text-foreground flex items-center gap-2"><GraduationCap size={14} /> Carrera</Label>
                            <Input
                                {...register('major')}
                                className="neo-input"
                                placeholder="Ej. Ingeniería"
                            />
                            {errors.major && <p className="text-xs font-bold text-primary italic uppercase">{errors.major.message}</p>}
                        </div>

                        {/* Credenciales */}
                        <div className="space-y-2">
                            <Label className="text-xs font-semibold text-foreground flex items-center gap-2"><AtSign size={14} /> Correo</Label>
                            <Input
                                {...register('email')}
                                type="email"
                                className="neo-input"
                                placeholder="correo@ejemplo.com"
                            />
                            {errors.email && <p className="text-xs font-bold text-primary italic uppercase">{errors.email.message}</p>}
                        </div>
                        <div className="space-y-2">
                            <Label className="text-xs font-semibold text-foreground flex items-center gap-2"><Lock size={14} /> Contraseña</Label>
                            <Input
                                {...register('password')}
                                type="password"
                                className="neo-input"
                                placeholder="••••••••"
                            />
                            {errors.password && <p className="text-xs font-bold text-primary italic uppercase">{errors.password.message}</p>}
                        </div>
                    </div>

                    <button
                        type="submit"
                        className="group w-full h-20 bg-foreground text-background text-xl font-semibold tracking-widest border border-foreground/10 shadow-md hover:shadow-lg hover:-translate-y-1 transition-all flex items-center justify-center gap-4 disabled:opacity-70"
                        disabled={isLoading}
                    >
                        {isLoading ? (
                            <Loader2 className="h-8 w-8 animate-spin" />
                        ) : (
                            <>
                                CREAR MI CUENTA
                                <CheckCircle2 className="group-hover:scale-125 transition-transform text-primary" />
                            </>
                        )}
                    </button>

                    <div className="relative flex items-center py-2 mt-4">
                        <div className="flex-grow border-t-2 border-slate-200"></div>
                        <span className="flex-shrink-0 mx-4 text-xs font-bold text-slate-400 uppercase tracking-widest">O</span>
                        <div className="flex-grow border-t-2 border-slate-200"></div>
                    </div>

                    <button
                        type="button"
                        onClick={() => googleLogin()}
                        disabled={isLoading || isGoogleLoading}
                        className="group w-full h-20 bg-card text-foreground text-lg font-semibold tracking-widest border border-foreground/10 shadow-md hover:bg-background transition-all flex items-center justify-center gap-4 disabled:opacity-70 mt-6"
                    >
                        {isGoogleLoading ? (
                            <Loader2 className="h-8 w-8 animate-spin" />
                        ) : (
                            <>
                                <Globe size={28} className="text-black group-hover:-rotate-12 transition-transform" />
                                REGISTRARSE CON GOOGLE
                            </>
                        )}
                    </button>
                </form>

                <div className="mt-12 text-center border-t-2 border-foreground/10 pt-8">
                    <p className="font-bold text-muted-foreground uppercase text-sm mb-4">¿Ya eres parte de la red?</p>
                    <Link
                        href="/login"
                        className="inline-block px-10 py-3 bg-primary text-primary-foreground border border-foreground/10 font-semibold text-sm hover:bg-foreground hover:text-background transition-all shadow-md hover:shadow-lg"
                    >
                        INICIAR SESIÓN
                    </Link>
                </div>
            </div>
        </div>
    );
}
