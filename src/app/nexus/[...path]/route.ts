import { NextRequest, NextResponse } from 'next/server';

/**
 * Puente Proxy Nexus (Server-side)
 * 
 * Actúa como intermediario entre Vercel y AWS EC2.
 * Compatible con Next.js 14.2+ (params puede ser Promise).
 */

const BACKEND_URL = 'http://52.201.136.58/api';

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
    // Handle both sync and async params (Next.js 14 vs 15 compatibility)
    const resolvedParams = context.params instanceof Promise 
        ? await context.params 
        : context.params;
    
    const pathSegments = resolvedParams?.path || [];
    const path = pathSegments.join('/');
    const searchParams = request.nextUrl.search;
    const targetUrl = `${BACKEND_URL}/${path}${searchParams}`;

    console.log(`[Nexus Bridge] ${request.method} -> ${targetUrl}`);

    const headers = new Headers(request.headers);
    headers.delete('host');
    headers.delete('connection');
    headers.delete('transfer-encoding');

    try {
        const fetchOptions: RequestInit = {
            method: request.method,
            headers: headers,
            cache: 'no-store',
        };

        if (['POST', 'PUT', 'PATCH'].includes(request.method)) {
            try {
                const body = await request.text();
                if (body && body.length > 0) {
                    fetchOptions.body = body;
                }
            } catch {
                // Empty body is ok for some requests
            }
        }

        const response = await fetch(targetUrl, fetchOptions);
        const responseBody = await response.text();

        const responseHeaders = new Headers();
        response.headers.forEach((value, key) => {
            if (!['content-encoding', 'transfer-encoding', 'content-length'].includes(key.toLowerCase())) {
                responseHeaders.set(key, value);
            }
        });

        return new NextResponse(responseBody, {
            status: response.status,
            statusText: response.statusText,
            headers: responseHeaders,
        });

    } catch (error: any) {
        console.error(`[Nexus Bridge ERROR]:`, error?.message || error);
        return NextResponse.json(
            { error: 'Backend connection failed', details: error?.message || 'Unknown error', target: targetUrl },
            { status: 502 }
        );
    }
}
