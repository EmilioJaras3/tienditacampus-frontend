'use client';

import { GoogleOAuthProvider } from '@react-oauth/google';

export function GoogleProvider({ children }: { children: React.ReactNode }) {
    const clientId = process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID;

    if (!clientId && typeof window !== 'undefined') {
        console.error('❌ CRITICAL ERROR: NEXT_PUBLIC_GOOGLE_CLIENT_ID is not defined! Google Login will NOT work.');
    }

    // Provide a dummy client ID placeholder just to prevent context crashing, 
    // but the error above warns the developer.
    const effectiveClientId = clientId || 'missing_client_id_placeholder.apps.googleusercontent.com';

    return (
        <GoogleOAuthProvider clientId={effectiveClientId}>
            {children}
        </GoogleOAuthProvider>
    );
}
