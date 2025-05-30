# Blockchain Football Betting DApp

## Mô tả
Dự án này là một ứng dụng web đặt cược bóng đá sử dụng smart contract trên Ethereum (testnet Sepolia). Gồm 2 phần:
- **Smart Contract**: Quản lý trận đấu, đặt cược, nhập kết quả, trả thưởng (Solidity)
- **Frontend**: Giao diện React đơn giản, kết nối Metamask, tương tác contract

## Cấu trúc thư mục
```
blockchain-betting/
├── smart-contract/      # Chứa code Solidity và script deploy
├── frontend/            # React app kết nối contract
└── README.md            # Hướng dẫn sử dụng
```

## Các bước triển khai

### 1. Deploy Smart Contract
- Cài đặt Node.js, npm, Hardhat
- Deploy contract lên Sepolia testnet
- Lưu lại địa chỉ contract và ABI

### 2. Chạy Frontend
- Cài đặt Node.js, npm
- Cấu hình địa chỉ contract, ABI
- Chạy React app, kết nối Metamask

## Yêu cầu
- Ví Metamask (đã kết nối Sepolia testnet, có ETH testnet)
- Node.js >= 16

## Hướng dẫn chi tiết sẽ có trong từng thư mục! # FBBetting
