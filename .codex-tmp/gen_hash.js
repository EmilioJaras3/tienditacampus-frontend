const {hash} = require('@node-rs/argon2');
hash('Campus2026!', {memoryCost:19456, timeCost:2, parallelism:1}).then(h => console.log(h));
