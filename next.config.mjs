/** @type {import('next').NextConfig} */
const nextConfig = {
    // Habilitar standalone output para Docker
    output: 'standalone',
    eslint: {
        ignoreDuringBuilds: true,
    },
    typescript: {
        ignoreBuildErrors: true,
    },

    // PWA headers
    async headers() {
        return [
            {
                source: '/(.*)',
                headers: [
                    {
                        key: 'X-Content-Type-Options',
                        value: 'nosniff',
                    },
                    {
                        key: 'X-Frame-Options',
                        value: 'DENY',
                    },
                    {
                        key: 'X-XSS-Protection',
                        value: '1; mode=block',
                    },
                ],
            },
        ];
    },

    // Rewrites para el API (desarrollo sin nginx)
    async rewrites() {
        return [
            {
                source: '/api/:path*',
<<<<<<< HEAD
                destination: 'http://localhost:3005/api/:path*',
=======
                destination: `${process.env.NEXT_PUBLIC_API_URL || 'http://98.88.194.19:3001/api'}/:path*`,
>>>>>>> 7581f339f92426519e3db14454fa784b8a17ce53
            },
        ];
    },
};

export default nextConfig;
