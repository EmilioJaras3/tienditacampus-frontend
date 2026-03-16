import type { Metadata } from 'next';
import './globals.css';
import { Toaster } from 'sonner';
import { PwaRegister } from '@/components/pwa-register';
import { GoogleProvider } from '@/components/providers/google-provider';
import { TermsBlockingOverlay } from '@/components/terms-blocking-overlay';

export const metadata: Metadata = {
    title: 'Antigrabyty',
    description: 'Compra snacks, apuntes y merch a tus compañeros universitarios. Vende tus productos sin intermediarios.',
    manifest: '/manifest.json',
};

export default function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    return (
        <html lang="es">
            <body className="antialiased">
                <GoogleProvider>
                    <TermsBlockingOverlay />
                    <main className="min-h-screen">
                        {children}
                    </main>
                    <footer className="py-6 border-t border-foreground/5 flex flex-col items-center gap-2 opacity-30 select-none">
                        <span className="text-[8px] font-bold uppercase tracking-[0.2em]">TienditaCampus © 2026 | Marco Legal Aplicado</span>
                        <div className="flex gap-4 text-[7px] font-bold uppercase tracking-widest">
                            <span>Seguridad Universitaria</span>
                            <span>Términos de Convivencia</span>
                        </div>
                    </footer>
                </GoogleProvider>
                <PwaRegister />
                <Toaster position="top-center" richColors />
            </body>
        </html>
    );
}
