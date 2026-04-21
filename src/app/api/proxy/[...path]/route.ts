import { NextRequest, NextResponse } from 'next/server';

/**
 * Proxy Bridge (Server-side)
 * 
 * Frontend -> /api/proxy/auth/login -> BACKEND_PROXY_URL/auth/login
 */

function getBackendUrl() {
    const rawUrl = process.env.BACKEND_PROXY_URL?.trim();
    if (!rawUrl) {
        throw new Error('BACKEND_PROXY_URL no está configurada');
    }
    return rawUrl.replace(/\/+$/, '');
}

export const dynamic = 'force-dynamic';
export const runtime = 'nodejs';

export async function GET(request: NextRequest, context: any) {
    return proxyRequest(request, context);
}

export async function POST(request: NextRequest, context: any) {
    return proxyRequest(request, context);
}

export async function PUT(request: NextRequest, context: any) {
    return proxyRequest(request, context);
}

export async function PATCH(request: NextRequest, context: any) {
    return proxyRequest(request, context);
}

export async function DELETE(request: NextRequest, context: any) {
    return proxyRequest(request, context);
}

async function proxyRequest(request: NextRequest, context: any) {
    let backendUrl: string;
    try {
        backendUrl = getBackendUrl();
    } catch (error: any) {
        return NextResponse.json(
            {
                error: 'Backend proxy no configurado',
                details: error?.message || 'Falta BACKEND_PROXY_URL',
            },
            { status: 500 },
        );
    }

    const resolvedParams = context.params instanceof Promise 
        ? await context.params 
        : context.params;
    
    const pathSegments = resolvedParams?.path || [];
    const path = pathSegments.join('/');
    const searchParams = request.nextUrl.search;
    const targetUrl = `${backendUrl}/${path}${searchParams}`;

    console.log(`[Proxy Bridge] ${request.method} -> ${targetUrl}`);

    // Build clean headers - only forward what the backend needs
    const headers: Record<string, string> = {
        'Content-Type': request.headers.get('content-type') || 'application/json',
    };

    // Forward Authorization if present
    const auth = request.headers.get('authorization');
    if (auth) {
        headers['Authorization'] = auth;
    }

    // Forward Accept
    const accept = request.headers.get('accept');
    if (accept) {
        headers['Accept'] = accept;
    }

    try {
        const fetchOptions: RequestInit = {
            method: request.method,
            headers: headers,
        };

        // Forward body for methods that have one
        if (['POST', 'PUT', 'PATCH'].includes(request.method)) {
            try {
                const bodyText = await request.text();
                if (bodyText && bodyText.length > 0) {
                    fetchOptions.body = bodyText;
                }
            } catch {
                // Empty body is fine
            }
        }

        const response = await fetch(targetUrl, fetchOptions);
        const responseBody = await response.text();

        // Build clean response headers
        const responseHeaders = new Headers();
        const contentType = response.headers.get('content-type');
        if (contentType) {
            responseHeaders.set('content-type', contentType);
        }

        // Forward CORS headers from backend
        response.headers.forEach((value, key) => {
            if (key.toLowerCase().startsWith('access-control-') || 
                key.toLowerCase() === 'x-request-id' ||
                key.toLowerCase() === 'set-cookie') {
                responseHeaders.set(key, value);
            }
        });

        return new NextResponse(responseBody, {
            status: response.status,
            statusText: response.statusText,
            headers: responseHeaders,
        });

    } catch (error: any) {
        console.error(`[Proxy Bridge ERROR]:`, error?.message || error);
        return NextResponse.json(
            { 
                error: 'Backend connection failed', 
                details: error?.message || 'Unknown error', 
                target: targetUrl 
            },
            { status: 502 }
        );
    }
}
