const mockedAccountId = 'mockedAccountId';
const mockedWebStoreId = 'mockedWebStoreId';
const mockedCartData = [
    {
        Owner: {
            Name: 'Lauren Boyle',
            Id: 'mockedOwnerId1'
        },
        Id: 'mockedCartId1',
        OwnerId: 'mockedOwnerId1',
        CurrencyIsoCode: 'USD',
        TotalProductAmount: 549.99,
        Name: 'Cart'
    },
    {
        Owner: {
            Name: 'Arthur Song',
            Id: 'mockedOwnerId2'
        },
        Id: 'mockedCartId2',
        OwnerId: 'mockedOwnerId2',
        CurrencyIsoCode: 'USD',
        TotalProductAmount: 463.97,
        Name: 'Cart'
    }
];

const mockedUserData = [
    {
        Id: 'mockedOwnerId1',
        IsActive: true,
        Name: 'Lauren Boyle',
        Email: 'mockedEmail1@example.com',
        Title: 'Human Resources Manager'
    },
    {
        Id: 'mockedOwnerId2',
        IsActive: true,
        Name: 'Arthur Song',
        Email: 'mockedEmail2@example.com',
        Title: 'Marketing Director'
    }
];

export {
    mockedAccountId,
    mockedWebStoreId,
    mockedCartData,
    mockedUserData
};