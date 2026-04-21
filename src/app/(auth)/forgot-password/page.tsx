'use client';

import Link from 'next/link';
import { Mail, ShieldAlert, ArrowLeft } from 'lucide-react';

export default function ForgotPasswordPage() {
    return (
        <div className="w-full max-w-md mx-auto">
            <div className="mb-10 text-center lg:text-left">
                <div className="inline-flex h-20 w-20 items-center justify-center border-4 border-foreground bg-secondary text-secondary-foreground shadow-neo mb-8 -rotate-3 rounded-2xl">
                    <ShieldAlert size={40} />
                </div>
                <h1 className="text-5xl font-bold tracking-tighter text-foreground leading-none mb-4 uppercase">
                    Recupera tu <span className="text-primary italic">acceso</span>
                </h1>
                <p className="text-lg font-bold text-muted-foreground border-l-8 border-primary pl-6 mt-6 uppercase italic">
                    Esta vista ya existe para que el login no apunte a una ruta rota.
                </p>
            </div>

            <div className="border-4 border-foreground bg-card p-10 shadow-neo-lg rounded-3xl space-y-6">
                <div className="flex items-start gap-4">
                    <div className="mt-1 inline-flex h-12 w-12 items-center justify-center rounded-xl border-2 border-foreground bg-background">
                        <Mail size={20} />
                    </div>
                    <div className="space-y-3">
                        <p className="text-base font-bold text-foreground uppercase">
                            Restablecimiento de contraseña
                        </p>
                        <p className="text-sm text-muted-foreground leading-6">
                            El backend actual no expone todavía un endpoint público de recuperación.
                            Si tu cuenta fue bloqueada por intentos fallidos, espera el tiempo de desbloqueo
                            o usa acceso con Google si tu cuenta ya está vinculada.
                        </p>
                        <p className="text-sm text-muted-foreground leading-6">
                            Si eres administrador, también puedes usar el flujo de rescate configurado en backend.
                        </p>
                    </div>
                </div>

                <div className="flex flex-col gap-4 sm:flex-row">
                    <Link
                        href="/login"
                        className="flex-1 h-14 border-2 border-foreground bg-foreground text-background font-bold tracking-widest rounded-xl flex items-center justify-center gap-2 hover:-translate-y-0.5 transition-all"
                    >
                        <ArrowLeft size={18} />
                        VOLVER AL LOGIN
                    </Link>
                    <Link
                        href="/register"
                        className="flex-1 h-14 border-2 border-primary bg-primary text-primary-foreground font-bold tracking-widest rounded-xl flex items-center justify-center hover:-translate-y-0.5 transition-all"
                    >
                        CREAR CUENTA
                    </Link>
                </div>
            </div>
        </div>
    );
}
