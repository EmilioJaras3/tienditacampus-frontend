import { NextRequest, NextResponse } from 'next/server';

/**
 * Puente Proxy Nexus (Server-side)
 * 
 * Actúa como intermediario entre Vercel y AWS EC2 para evitar errores de red 502/503.
 */

const BACKEND_URL = 'http://52.201.136.58/api';

export async function GET(request: NextRequest, { params }: { params: { path: string[] } }) {
    return proxyRequest(request, params);
}

export async function POST(request: NextRequest, { params }: { params: { path: string[] } }) {
    return proxyRequest(request, params);
}

export async function PUT(request: NextRequest, { params }: { params: { path: string[] } }) {
    return proxyRequest(request, params);
}

export async function PATCH(request: NextRequest, { params }: { params: { path: string[] } }) {
    return proxyRequest(request, params);
}

export async function DELETE(request: NextRequest, { params }: { params: { path: string[] } }) {
    return proxyRequest(request, params);
}

async function proxyRequest(request: NextRequest, params: { path: string[] }) {
    const path = params.path.join('/');
    const searchParams = request.nextUrl.search;
    const targetUrl = `${BACKEND_URL}/${path}${searchParams}`;

    console.log(`[Nexus Bridge] Forwarding ${request.method} to: ${targetUrl}`);

    const headers = new Headers(request.headers);
    headers.delete('host');
    headers.delete('connection');

    try {
        const fetchOptions: RequestInit = {
            method: request.method,
            headers: headers,
            cache: 'no-store',
        };

        if (['POST', 'PUT', 'PATCH'].includes(request.method)) {
            const body = await request.blob();
            if (body.size > 0) {
                fetchOptions.body = body;
            }
        }

        const response = await fetch(targetUrl, fetchOptions);
        const data = await response.blob();

        const responseHeaders = new Headers(response.headers);
        responseHeaders.delete('content-encoding');
        responseHeaders.delete('content-length');

        return new NextResponse(data, {
            status: response.status,
            statusText: response.statusText,
            headers: responseHeaders,
        });

    } catch (error: any) {
        console.error(`[Nexus Bridge ERROR]:`, error);
        return NextResponse.json(
            { error: 'Connection to AWS Backend Failed', details: error.message },
            { status: 502 }
        );
    }
}
