FROM node:20-alpine

WORKDIR /app

COPY report.js package.json ./

RUN ["npm", "install"]

CMD ["node", "report.js"]