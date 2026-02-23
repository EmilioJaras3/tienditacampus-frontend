'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { toast } from 'sonner';
import { authService } from '../../../services/auth.service';
import { Button } from '../../../components/ui/button';
import { Input } from '../../../components/ui/input';
import { Label } from '../../../components/ui/label';
import { Card } from '../../../components/ui/card';
import { Loader2, UserPlus, Store, ShoppingBag } from 'lucide-react';
import { cn } from '../../../lib/utils';

// Esquema de validación que coincide con el backend
const registerSchema = z
    .object({
        firstName: z.string().min(1, 'El nombre es requerido'),
        lastName: z.string().min(1, 'Los apellidos son requeridos'),
        email: z.string().email('Email inválido'),
        phone: z.string().optional(),
        role: z.enum(['seller', 'buyer'], {
            message: 'Selecciona tu tipo de cuenta',
        }),
        password: z
            .string()
            .min(8, 'Mínimo 8 caracteres')
            .max(72, 'Máximo 72 caracteres')
            .regex(/[A-Z]/, 'Debe contener al menos una mayúscula')
            .regex(/[a-z]/, 'Debe contener al menos una minúscula')
            .regex(/[0-9]/, 'Debe contener al menos un número'),
        confirmPassword: z.string(),
    })
    .refine((data) => data.password === data.confirmPassword, {
        message: 'Las contraseñas no coinciden',
        path: ['confirmPassword'],
    });

type RegisterFormData = z.infer<typeof registerSchema>;

const ROLE_OPTIONS = [
    {
        value: 'seller' as const,
        label: 'Soy Vendedor',
        description: 'Vende comida y productos en el campus',
        icon: Store,
        gradient: 'from-blue-500 to-indigo-600',
        ring: 'ring-blue-500',
        bg: 'bg-blue-50',
    },
    {
        value: 'buyer' as const,
        label: 'Soy Comprador',
        description: 'Explora y compra lo que venden tus compañeros',
        icon: ShoppingBag,
        gradient: 'from-emerald-500 to-teal-600',
        ring: 'ring-emerald-500',
        bg: 'bg-emerald-50',
    },
];

export default function RegisterPage() {
    const router = useRouter();
    const [isLoading, setIsLoading] = useState(false);
    const [selectedRole, setSelectedRole] = useState<'seller' | 'buyer' | null>(null);

    const {
        register,
        handleSubmit,
        setValue,
        formState: { errors },
    } = useForm<RegisterFormData>({
        resolver: zodResolver(registerSchema),
    });

    const handleRoleSelect = (role: 'seller' | 'buyer') => {
        setSelectedRole(role);
        setValue('role', role, { shouldValidate: true });
    };

    const onSubmit = async (data: RegisterFormData) => {
        setIsLoading(true);
        try {
            const { confirmPassword, ...registerData } = data;
            const response = await authService.register(registerData);
            toast.success('¡Cuenta creada exitosamente!');
            // Redirigir según el rol del usuario recién creado
            if (response.user.role === 'buyer') {
                router.push('/buyer/dashboard');
            } else {
                router.push('/dashboard');
            }
        } catch (error: any) {
            toast.error(error.message || 'Error al registrarse');
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div className="space-y-6">
            <div className="flex flex-col space-y-2 text-center lg:text-left">
                <div className="mb-2 flex justify-center lg:justify-start">
                    <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-gradient-to-br from-primary to-blue-600 text-white shadow-lg shadow-primary/30">
                        <UserPlus size={28} />
                    </div>
                </div>
                <h1 className="text-3xl font-bold tracking-tight text-foreground">Crear Cuenta</h1>
                <p className="text-sm text-muted-foreground">
                    Únete a TienditaCampus — primero cuéntanos cómo usarás la plataforma.
                </p>
            </div>

            <Card className="border-none shadow-none bg-transparent">
                <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">

                    {/* ── Selector de Rol ─────────────────────────────────── */}
                    <div className="space-y-2">
                        <Label className="text-xs uppercase tracking-widest text-muted-foreground/70 font-semibold">
                            Tipo de Cuenta
                        </Label>
                        <div className="grid grid-cols-2 gap-3">
                            {ROLE_OPTIONS.map((option) => {
                                const Icon = option.icon;
                                const isSelected = selectedRole === option.value;
                                return (
                                    <button
                                        key={option.value}
                                        type="button"
                                        onClick={() => handleRoleSelect(option.value)}
                                        className={cn(
                                            'relative flex flex-col items-center gap-2 rounded-xl border-2 p-4 text-center transition-all duration-200 cursor-pointer',
                                            isSelected
                                                ? `border-transparent ring-2 ${option.ring} ${option.bg}`
                                                : 'border-border bg-background hover:border-primary/30 hover:bg-muted/40',
                                        )}
                                    >
                                        <div className={cn(
                                            'flex h-10 w-10 items-center justify-center rounded-full text-white shadow-md',
                                            `bg-gradient-to-br ${option.gradient}`,
                                        )}>
                                            <Icon size={20} />
                                        </div>
                                        <div>
                                            <p className="text-sm font-semibold text-foreground">{option.label}</p>
                                            <p className="text-[10px] text-muted-foreground leading-tight mt-0.5">{option.description}</p>
                                        </div>
                                        {isSelected && (
                                            <span className="absolute top-2 right-2 flex h-4 w-4 items-center justify-center rounded-full bg-current">
                                                <svg className="h-2.5 w-2.5 text-white" viewBox="0 0 12 12" fill="currentColor">
                                                    <path d="M10 3L5 8.5 2 5.5" stroke="white" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
                                                </svg>
                                            </span>
                                        )}
                                    </button>
                                );
                            })}
                        </div>
                        {/* Hidden input for z.object validation */}
                        <input type="hidden" {...register('role')} />
                        {errors.role && (
                            <p className="text-xs font-medium text-destructive animate-fade-in">{errors.role.message}</p>
                        )}
                    </div>

                    {/* ── Datos personales ────────────────────────────────── */}
                    <div className="space-y-4">
                        <div className="grid grid-cols-2 gap-4">
                            <div className="space-y-2">
                                <Label htmlFor="firstName" className="text-xs uppercase tracking-widest text-muted-foreground/70 font-semibold">
                                    Nombre
                                </Label>
                                <Input
                                    id="firstName"
                                    className="h-11 border-input bg-background focus:ring-primary/20 transition-all"
                                    {...register('firstName')}
                                    disabled={isLoading}
                                />
                                {errors.firstName && (
                                    <p className="text-xs font-medium text-destructive animate-fade-in">
                                        {errors.firstName.message}
                                    </p>
                                )}
                            </div>
                            <div className="space-y-2">
                                <Label htmlFor="lastName" className="text-xs uppercase tracking-widest text-muted-foreground/70 font-semibold">
                                    Apellidos
                                </Label>
                                <Input
                                    id="lastName"
                                    className="h-11 border-input bg-background focus:ring-primary/20 transition-all"
                                    {...register('lastName')}
                                    disabled={isLoading}
                                />
                                {errors.lastName && (
                                    <p className="text-xs font-medium text-destructive animate-fade-in">
                                        {errors.lastName.message}
                                    </p>
                                )}
                            </div>
                        </div>

                        <div className="space-y-2">
                            <Label htmlFor="email" className="text-xs uppercase tracking-widest text-muted-foreground/70 font-semibold">
                                Email Institucional
                            </Label>
                            <Input
                                id="email"
                                type="email"
                                placeholder="usuario@universidad.edu"
                                className="h-11 border-input bg-background focus:ring-primary/20 transition-all"
                                {...register('email')}
                                disabled={isLoading}
                            />
                            {errors.email && (
                                <p className="text-xs font-medium text-destructive animate-fade-in">{errors.email.message}</p>
                            )}
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                            <div className="space-y-2">
                                <Label htmlFor="password" className="text-xs uppercase tracking-widest text-muted-foreground/70 font-semibold">
                                    Contraseña
                                </Label>
                                <Input
                                    id="password"
                                    type="password"
                                    className="h-11 border-input bg-background focus:ring-primary/20 transition-all"
                                    {...register('password')}
                                    disabled={isLoading}
                                />
                            </div>
                            <div className="space-y-2">
                                <Label htmlFor="confirmPassword" className="text-xs uppercase tracking-widest text-muted-foreground/70 font-semibold">
                                    Confirmar
                                </Label>
                                <Input
                                    id="confirmPassword"
                                    type="password"
                                    className="h-11 border-input bg-background focus:ring-primary/20 transition-all"
                                    {...register('confirmPassword')}
                                    disabled={isLoading}
                                />
                            </div>
                        </div>

                        {(errors.password || errors.confirmPassword) && (
                            <div className="space-y-1">
                                {errors.password && <p className="text-xs font-medium text-destructive animate-fade-in">{errors.password.message}</p>}
                                {errors.confirmPassword && <p className="text-xs font-medium text-destructive animate-fade-in">{errors.confirmPassword.message}</p>}
                            </div>
                        )}

                        <div className="rounded-lg bg-muted p-3 text-[10px] text-muted-foreground flex items-start space-x-2">
                            <div className="mt-0.5 h-1 w-1 rounded-full bg-primary shrink-0" />
                            <p>Mínimo 8 caracteres, incluye una mayúscula, una minúscula y un número para mayor seguridad.</p>
                        </div>
                    </div>

                    <Button
                        type="submit"
                        className="w-full h-11 text-sm font-bold bg-primary hover:bg-primary-dark transition-all duration-300 shadow-md shadow-primary/20"
                        disabled={isLoading}
                    >
                        {isLoading ? (
                            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                        ) : (
                            'Crear mi Cuenta'
                        )}
                    </Button>
                </form>

                <div className="mt-6 text-center text-sm text-muted-foreground">
                    ¿Ya eres parte de TienditaCampus?{' '}
                    <Link href="/auth/login" className="font-bold text-primary hover:text-primary-dark transition-colors">
                        Inicia Sesión
                    </Link>
                </div>
            </Card>
        </div>
    );
}
